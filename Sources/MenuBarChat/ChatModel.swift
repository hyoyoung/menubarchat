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

    let settings = SettingsStore()

    private var streamTask: Task<Void, Never>?

    func send() {
        let prompt = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !prompt.isEmpty, !isStreaming else { return }
        draft = ""
        messages.append(Message(role: .user, text: prompt))
        if let index = messages.indices.last, Self.isLongPaste(prompt) {
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

    private struct AttachmentRef {
        let isWeb: Bool
        let number: Int
    }

    private func mentionedAttachments() -> [AttachmentRef] {
        guard let text = messages.last?.text,
              let regex = try? NSRegularExpression(pattern: "ID(\\d+)(p?)")
        else { return [] }
        let range = NSRange(text.startIndex..., in: text)
        return regex.matches(in: text, range: range).compactMap { match in
            guard let number = Range(match.range(at: 1), in: text),
                  let value = Int(text[number])
            else { return nil }
            let isPaste = Range(match.range(at: 2), in: text) != nil
            return AttachmentRef(isWeb: !isPaste, number: value)
        }
    }

    private static func isLongPaste(_ text: String) -> Bool {
        text.split(separator: "\n", omittingEmptySubsequences: false).count > 10
    }

    private static func firstLine(of text: String) -> String {
        let line = text.split(separator: "\n", omittingEmptySubsequences: true).first.map(String.init) ?? ""
        return String(line.prefix(60))
    }

    private static func isURLOnly(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = PageFetcher.urls(in: trimmed).first else { return false }
        return url.absoluteString == trimmed
    }

    private func apiContent(for message: Message, isLast: Bool) -> String {
        let pages = message.pages.filter { $0.error == nil }
        guard isLast else {
            var content = message.text
            if message.pasteID > 0 {
                content = "[Text ID\(message.pasteID)p (\(Self.firstLine(of: message.text))) — mention \"ID\(message.pasteID)p\" to re-include]"
            }
            for page in pages {
                content += "\n\n[Page ID\(page.id) (\(page.host)) — mention \"ID\(page.id)\" to re-include]"
            }
            return content
        }
        var content = message.text
        if message.pasteID > 0 {
            content = "[Pasted text ID\(message.pasteID)p]\n\(message.text)"
        }
        for page in pages {
            content += "\n\n[Page ID\(page.id) — \(page.host)]\n\(page.text)"
        }
        var includedPages = Set(pages.map(\.id))
        var includedPastes: Set<Int> = [message.pasteID]
        for ref in mentionedAttachments() {
            if ref.isWeb {
                guard !includedPages.contains(ref.number),
                      let page = messages.flatMap(\.pages).first(where: { $0.error == nil && $0.id == ref.number })
                else { continue }
                includedPages.insert(ref.number)
                content += "\n\n[Page ID\(page.id) — \(page.host)]\n\(page.text)"
            } else {
                guard !includedPastes.contains(ref.number),
                      let source = messages.first(where: { $0.pasteID == ref.number })
                else { continue }
                includedPastes.insert(ref.number)
                content += "\n\n[Pasted text ID\(ref.number)p]\n\(source.text)"
            }
        }
        let instruction = settings.urlHandling.trimmingCharacters(in: .whitespacesAndNewlines)
        if !instruction.isEmpty, Self.isURLOnly(message.text) || message.pasteID > 0 {
            content += "\n\n[Instruction: \(instruction) — unless the user already asked something specific above]"
        }
        return content
    }

    private func stream() async {
        let contents = messages.enumerated().map { index, message in
            (role: message.role.rawValue, content: apiContent(for: message, isLast: index == messages.count - 1))
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
