import AppKit
import Foundation

struct Message: Identifiable, Equatable {
    let id = UUID()
    let role: Role
    var text: String
    var reasoning = ""
    var promptTokens: Int?
    var completionTokens: Int?
    var pages: [FetchedPage] = []
    var isReasoningExpanded = false
    var pasteID = 0
    var isTextExpanded = false

    enum Role: String {
        case user, assistant
    }
}

@MainActor
final class ChatModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var draft = ""
    @Published var isStreaming = false
    @Published var isFetchingPage = false
    @Published var copiedMessageID: UUID?
    @Published var hoveredMessageID: UUID?
    private var nextAttachmentID = 1
    @Published var showsSettings = false
    @Published var queuedMessage: String?
    @Published var stagedPaste: String?
    @Published var pasteNotice: String?
    @Published var followsBottom = true

    let settings = SettingsStore()

    private var streamTask: Task<Void, Never>?

    func send() {
        var prompt = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        if let staged = stagedPaste {
            stagedPaste = nil
            prompt = prompt.isEmpty ? staged : prompt + "\n" + staged
        }
        guard !prompt.isEmpty else { return }
        if isStreaming {
            if queuedMessage == nil {
                queuedMessage = prompt
                draft = ""
            }
            return
        }
        guard hasAPIKey else {
            showEmptyKeyHint()
            return
        }
        draft = ""
        sendNow(prompt)
    }

    private var hasAPIKey: Bool {
        !settings.apiKey.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func showEmptyKeyHint() {
        messages.append(Message(role: .assistant, text: "Error: API key is empty — open settings"))
    }

    func clearQueued() {
        queuedMessage = nil
    }

    func stagePaste(_ text: String) {
        stagedPaste = text
    }

    func clearStaged() {
        stagedPaste = nil
    }

    func unstageToDraft() {
        guard let staged = stagedPaste else { return }
        stagedPaste = nil
        if draft.isEmpty {
            draft = staged
        } else {
            draft += "\n" + staged
        }
    }

    func showPasteNotice() {
        pasteNotice = "붙여넣을 수 있는 것은 텍스트뿐입니다 — 이미지·파일은 지원하지 않습니다"
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            pasteNotice = nil
        }
    }

    func unqueueToDraft() {
        guard let queued = queuedMessage else { return }
        queuedMessage = nil
        if draft.isEmpty {
            draft = queued
        } else {
            draft += "\n" + queued
        }
    }

    private func sendNow(_ prompt: String) {
        guard hasAPIKey else {
            showEmptyKeyHint()
            return
        }
        followsBottom = true
        messages.append(Message(role: .user, text: prompt))
        if let index = messages.indices.last, PromptComposer.isLongPaste(prompt) {
            messages[index].pasteID = nextAttachmentID
            nextAttachmentID += 1
        }
        isStreaming = true
        showsSettings = false

        streamTask = Task {
            await fetchPagesForLastUserMessage()
            await stream()
            isStreaming = false
            streamTask = nil
            if let queued = queuedMessage {
                queuedMessage = nil
                sendNow(queued)
            }
        }
    }

    func stop() {
        streamTask?.cancel()
    }

    func clear() {
        stop()
        messages.removeAll()
    }

    func copyAnswer(_ message: Message) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(message.text, forType: .string)
        copiedMessageID = message.id
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            if copiedMessageID == message.id { copiedMessageID = nil }
        }
    }

    private func fetchPagesForLastUserMessage() async {
        guard let index = messages.indices.last, messages[index].role == .user else { return }
        // URLs embedded in a long paste are part of the pasted content, not a fetch target.
        guard messages[index].pasteID == 0 else { return }
        guard let url = PageFetcher.urls(in: messages[index].text).first else { return }
        if Task.isCancelled { return }
        isFetchingPage = true
        defer { isFetchingPage = false }
        var page = await PageFetcher.fetchPage(url)
        if Task.isCancelled { return }
        guard messages.indices.contains(index), messages[index].role == .user else { return }
        if page.error == nil {
            page.id = nextAttachmentID
            nextAttachmentID += 1
        }
        messages[index].pages.append(page)
    }

    private func stream() async {
        let contents = messages.enumerated().map { index, message in
            (role: message.role.rawValue, content: PromptComposer.apiContent(
                messages: messages,
                urlHandling: settings.urlHandling,
                for: message,
                isLast: index == messages.count - 1
            ))
        }
        do {
            let deltas = LLMClient.stream(
                baseURL: settings.baseURL,
                apiKey: settings.apiKey,
                model: settings.model,
                thinkingBudget: settings.thinkingBudget,
                webSearch: settings.webSearch,
                messages: contents
            )
            for try await delta in deltas {
                appendToAssistant(delta)
            }
        } catch {
            if Task.isCancelled { return }
            if let last = messages.last, last.role == .assistant,
                last.text.isEmpty, last.reasoning.isEmpty {
                messages.removeLast()
            }
            messages.append(Message(role: .assistant, text: "Error: \(error.localizedDescription)"))
        }
    }

    private func appendToAssistant(_ delta: LLMClient.Delta) {
        if let last = messages.last, last.role == .assistant {
            messages[messages.count - 1].reasoning += delta.reasoning
            messages[messages.count - 1].text += delta.content
            if let prompt = delta.promptTokens { messages[messages.count - 1].promptTokens = prompt }
            if let completion = delta.completionTokens { messages[messages.count - 1].completionTokens = completion }
        } else {
            var message = Message(role: .assistant, text: delta.content, reasoning: delta.reasoning)
            message.promptTokens = delta.promptTokens
            message.completionTokens = delta.completionTokens
            messages.append(message)
        }
    }
}
