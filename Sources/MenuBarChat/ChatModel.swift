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
    var imageData: Data?
    var imageID = 0
    var isReasoningExpanded = false
    var pasteID = 0
    var isTextExpanded = false
    var viaCommand = false
    var commandName: String?
    var pageBundleID = 0
    // Render-only caches (markdown parse, decoded thumbnail) — excluded
    // from equality; derived from the fields above.
    var cachedMarkdown: AttributedString?
    var cachedImage: NSImage?

    enum Role: String {
        case user, assistant
    }

    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.role == rhs.role
            && lhs.text == rhs.text
            && lhs.reasoning == rhs.reasoning
            && lhs.promptTokens == rhs.promptTokens
            && lhs.completionTokens == rhs.completionTokens
            && lhs.pages == rhs.pages
            && lhs.imageData == rhs.imageData
            && lhs.imageID == rhs.imageID
            && lhs.isReasoningExpanded == rhs.isReasoningExpanded
            && lhs.pasteID == rhs.pasteID
            && lhs.isTextExpanded == rhs.isTextExpanded
            && lhs.viaCommand == rhs.viaCommand
            && lhs.commandName == rhs.commandName
            && lhs.pageBundleID == rhs.pageBundleID
    }
}

@MainActor
final class ChatModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var draft = ""
    @Published var isStreaming = false
    @Published var isFetchingPage = false
    @Published var fetchingPageCount = 0
    @Published var copiedMessageID: UUID?
    @Published var hoveredMessageID: UUID?
    private var nextAttachmentID = 1
    @Published var showsSettings = false
    @Published var queuedMessage: String?
    private var queuedViaCommand = false
    private var queuedCommandName: String?
    @Published var stagedPaste: String?
    @Published var stagedImage: Data?
    @Published var pasteNotice: String?
    @Published var followsBottom = true

    let settings = SettingsStore()

    var supportsImageInput: Bool {
        settings.model.lowercased().contains("flash")
    }

    private var streamTask: Task<Void, Never>?

    func send() {
        var prompt = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        var viaCommand = false
        var commandName: String?
        if let command = SlashCommands.matchedCommand(in: prompt, commands: settings.availableCommands) {
            if command.name == "previous-news" {
                draft = ""
                showPreviousNews()
                return
            }
            prompt = SlashCommands.expand(prompt, commands: settings.availableCommands) ?? prompt
            prompt = SlashCommands.applyingLanguage(prompt, language: settings.appLanguage)
            prompt = prompt.replacingOccurrences(of: "{previous}", with: NewsHistory.previousContext(entries: NewsHistory.load()))
            draft = ""
            viaCommand = true
            commandName = command.name
        }
        if let staged = stagedPaste {
            stagedPaste = nil
            prompt = prompt.isEmpty ? staged : prompt + "\n" + staged
        }
        // Safety net: an image file path that reached the draft (drag flows)
        // is an image attachment at send time, never message text.
        if ImageEncoder.isImagePathString(prompt) {
            if let url = ImageEncoder.imageFileURL(fromPathString: prompt),
               supportsImageInput,
               let image = NSImage(contentsOf: url),
               let jpeg = ImageEncoder.jpegData(from: image) {
                stagedImage = jpeg
                prompt = ""
                draft = ""
            } else {
                draft = ""
                showPasteNotice()
                return
            }
        }
        guard !prompt.isEmpty || stagedImage != nil else { return }
        if isStreaming {
            if stagedImage == nil, queuedMessage == nil {
                queuedMessage = prompt
                queuedViaCommand = viaCommand
                queuedCommandName = commandName
                draft = ""
            }
            return
        }
        guard hasAPIKey else {
            showEmptyKeyHint()
            return
        }
        draft = ""
        sendNow(prompt, viaCommand: viaCommand, commandName: commandName)
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

    // Completion (click or Tab) finishes the /token to the full command
    // name only — the prompt itself expands at send time.
    func applyCommand(_ command: SlashCommand) {
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        let parts = trimmed.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
        let rest = parts.count > 1 ? " " + String(parts[1]) : ""
        draft = "/\(command.name)" + rest + " "
    }

    func stageImage(_ data: Data) {
        stagedImage = data
    }

    // Whatever route an image file path arrives by (drag, context-menu
    // paste, …), a path-only draft means an image attachment, not text.
    func convertDraftImage() {
        guard ImageEncoder.isImagePathString(draft) else { return }
        guard let url = ImageEncoder.imageFileURL(fromPathString: draft),
              supportsImageInput,
              let image = NSImage(contentsOf: url),
              let jpeg = ImageEncoder.jpegData(from: image)
        else {
            draft = ""
            showPasteNotice()
            return
        }
        stagedImage = jpeg
        draft = ""
    }

    func clearStagedImage() {
        stagedImage = nil
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

    private func sendNow(_ prompt: String, viaCommand: Bool = false, commandName: String? = nil) {
        guard hasAPIKey else {
            showEmptyKeyHint()
            return
        }
        followsBottom = true
        messages.append(Message(role: .user, text: prompt))
        if let index = messages.indices.last, viaCommand {
            messages[index].viaCommand = true
            messages[index].commandName = commandName
        }
        if let index = messages.indices.last, let staged = stagedImage {
            stagedImage = nil
            messages[index].imageData = staged
            messages[index].imageID = nextAttachmentID
            messages[index].cachedImage = NSImage(data: staged)
            nextAttachmentID += 1
        }
        if let index = messages.indices.last, PromptComposer.isLongPaste(prompt) {
            messages[index].pasteID = nextAttachmentID
            nextAttachmentID += 1
        }
        isStreaming = true
        showsSettings = false

        streamTask = Task {
            await fetchPagesForLastUserMessage()
            let finished = await stream()
            isStreaming = false
            streamTask = nil
            if finished {
                saveNewsHistoryIfNeeded()
            }
            if let queued = queuedMessage {
                queuedMessage = nil
                let wasCommand = queuedViaCommand
                let wasCommandName = queuedCommandName
                queuedViaCommand = false
                queuedCommandName = nil
                sendNow(queued, viaCommand: wasCommand, commandName: wasCommandName)
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
        let all = PageFetcher.urls(in: messages[index].text)
        guard !all.isEmpty else { return }
        // Only command-expanded messages fetch every URL (cap 10); regular
        // messages keep the single-first-URL behavior.
        let targets = messages[index].viaCommand ? Array(all.prefix(10)) : [all[0]]
        // Command messages carry one bundle ID for all pages; pages stay 0.
        if messages[index].viaCommand, messages[index].pageBundleID == 0 {
            messages[index].pageBundleID = nextAttachmentID
            nextAttachmentID += 1
        }
        if Task.isCancelled { return }
        isFetchingPage = true
        fetchingPageCount = targets.count
        defer {
            isFetchingPage = false
            fetchingPageCount = 0
        }
        var nextIndex = 0
        await withTaskGroup(of: FetchedPage.self) { group in
            func enqueueNext() {
                guard nextIndex < targets.count else { return }
                let url = targets[nextIndex]
                nextIndex += 1
                group.addTask { await PageFetcher.fetchPage(url) }
            }
            // Sliding window of 2: refill as each fetch completes.
            enqueueNext()
            if targets.count > 1 { enqueueNext() }
            while let fetched = await group.next() {
                if Task.isCancelled { group.cancelAll(); return }
                guard messages.indices.contains(index), messages[index].role == .user
                else { group.cancelAll(); return }
                var page = fetched
                if page.error == nil, !messages[index].viaCommand {
                    page.id = nextAttachmentID
                    nextAttachmentID += 1
                }
                messages[index].pages.append(page)
                enqueueNext()
            }
        }
    }

    private func stream() async -> Bool {
        let instruction = SlashCommands.applyingLanguage(settings.urlHandling, language: settings.appLanguage)
        let contents = PromptComposer.transcript(messages: messages, urlHandling: instruction)
        var lastParts: [[String: Any]]?
        if PromptComposer.needsImageParts(messages: messages) {
            lastParts = PromptComposer.imageParts(messages: messages, urlHandling: instruction)
        }
        do {
            let deltas = LLMClient.stream(
                baseURL: settings.baseURL,
                apiKey: settings.apiKey,
                model: settings.model,
                thinkingBudget: settings.thinkingBudget,
                webSearch: settings.webSearch,
                messages: contents,
                lastContentParts: lastParts
            )
            for try await delta in deltas {
                appendToAssistant(delta)
            }
            finalizeLastAssistantMarkdown()
            return true
        } catch {
            if Task.isCancelled { return false }
            if let last = messages.last, last.role == .assistant,
                last.text.isEmpty, last.reasoning.isEmpty {
                messages.removeLast()
            }
            messages.append(Message(role: .assistant, text: "Error: \(error.localizedDescription)"))
            return false
        }
    }

    // Local recall of the newest saved digest — no request, no refetch.
    private func showPreviousNews() {
        guard !isStreaming else { return }
        followsBottom = true
        let text = NewsHistory.load().first?.text ?? "저장된 다이제스트가 없습니다."
        messages.append(Message(role: .assistant, text: text))
        finalizeLastAssistantMarkdown()
    }

    private func saveNewsHistoryIfNeeded() {
        guard let assistant = messages.last, assistant.role == .assistant,
              let index = messages.firstIndex(where: { $0.id == assistant.id }),
              index > messages.startIndex
        else { return }
        let preceding = messages[index - 1]
        if preceding.viaCommand, preceding.commandName == "news" {
            NewsHistory.append(assistant.text)
        }
    }

    private func finalizeLastAssistantMarkdown() {
        guard let index = messages.indices.last,
              messages[index].role == .assistant,
              messages[index].cachedMarkdown == nil
        else { return }
        messages[index].cachedMarkdown = MessageView.markdown(messages[index].text)
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
