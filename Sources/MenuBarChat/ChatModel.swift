import AppKit
import Foundation

struct FetchedPage: Equatable {
    var id = 0
    let host: String
    let text: String
    let imageURL: URL?
    let error: String?
}

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

struct StreamError: LocalizedError {
    let status: Int
    let body: String

    var errorDescription: String? {
        "HTTP \(status): \(String(body.prefix(300)))"
    }
}

@MainActor
final class ChatModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var draft = ""
    @Published var isStreaming = false
    @Published var isFetchingPage = false
    @Published var copiedMessageID: UUID?
    private var nextAttachmentID = 1
    @Published var showsSettings = false

    @Published var apiKey: String { didSet { UserDefaults.standard.set(apiKey, forKey: "apiKey") } }
    @Published var baseURL: String { didSet { UserDefaults.standard.set(baseURL, forKey: "baseURL") } }
    @Published var model: String { didSet { UserDefaults.standard.set(model, forKey: "model") } }
    @Published var thinkingBudget: String { didSet { UserDefaults.standard.set(thinkingBudget, forKey: "thinkingBudget") } }
    @Published var webSearch: Bool { didSet { UserDefaults.standard.set(webSearch, forKey: "webSearch") } }
    @Published var urlHandling: String { didSet { UserDefaults.standard.set(urlHandling, forKey: "urlHandling") } }

    private var streamTask: Task<Void, Never>?

    init() {
        let defaults = UserDefaults.standard
        let env = ProcessInfo.processInfo.environment
        apiKey = defaults.string(forKey: "apiKey")
            ?? env["ZAI_API_KEY"] ?? env["Z_AI_API_KEY"] ?? ""
        baseURL = defaults.string(forKey: "baseURL") ?? "https://api.z.ai/api/coding/paas/v4"
        model = defaults.string(forKey: "model") ?? "glm-5.3-flash"
        thinkingBudget = defaults.string(forKey: "thinkingBudget") ?? "high"
        webSearch = (defaults.object(forKey: "webSearch") as? Bool) ?? false
        urlHandling = defaults.string(forKey: "urlHandling")
            ?? "summarize it in \(Self.systemLanguageName)"
    }

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

    private static var systemLanguageName: String {
        let code = Locale.current.language.languageCode?.identifier ?? "en"
        return Locale(identifier: "en_US").localizedString(forLanguageCode: code) ?? "English"
    }

    private func fetchPagesForLastUserMessage() async {
        guard let index = messages.indices.last, messages[index].role == .user else { return }
        guard let url = Self.urls(in: messages[index].text).first else { return }
        if Task.isCancelled { return }
        isFetchingPage = true
        defer { isFetchingPage = false }
        var page = await Self.fetchPage(url)
        if Task.isCancelled { return }
        guard messages.indices.contains(index), messages[index].role == .user else { return }
        if page.error == nil {
            page.id = nextAttachmentID
            nextAttachmentID += 1
        }
        messages[index].pages.append(page)
    }

    private static func urls(in text: String) -> [URL] {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let range = NSRange(text.startIndex..., in: text)
        return (detector?.matches(in: text, range: range) ?? [])
            .compactMap(\.url)
            .filter { $0.scheme == "http" || $0.scheme == "https" }
    }

    private static func fetchPage(_ url: URL) async -> FetchedPage {
        guard let host = url.host() else {
            return FetchedPage(host: url.absoluteString, text: "", imageURL: nil, error: "invalid URL")
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 15
        request.setValue(
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15",
            forHTTPHeaderField: "User-Agent"
        )
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
                return FetchedPage(host: host, text: "", imageURL: nil, error: "HTTP \(http.statusCode)")
            }
            let html = String(data: data, encoding: .utf8) ?? ""
            let text = await Self.plainText(fromHTML: html)
            guard !text.isEmpty else {
                return FetchedPage(host: host, text: "", imageURL: nil, error: "no content")
            }
            return FetchedPage(
                host: host,
                text: String(text.prefix(20_000)),
                imageURL: ogImage(in: html),
                error: nil
            )
        } catch {
            let reason = (error as? URLError)?.code == .timedOut ? "timeout" : "network error"
            return FetchedPage(host: host, text: "", imageURL: nil, error: reason)
        }
    }

    private static func ogImage(in html: String) -> URL? {
        guard let tag = html.range(of: "og:image"),
              let open = html[tag.upperBound...].range(of: "content=\"")?.upperBound,
              let close = html[open...].range(of: "\"")
        else { return nil }
        return URL(string: String(html[open..<close.lowerBound]))
    }

    // WebKit's HTML importer can stall its caller, so it runs off the main
    // actor behind a timeout; if it yields nothing we fall back to a tag strip.
    private static func plainText(fromHTML html: String) async -> String {
        let source = String(html.prefix(500_000))
        let importer = Task.detached(priority: .utility) { () -> String in
            ((try? NSAttributedString(
                html: Data(source.utf8),
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            ))?.string ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let converted: String? = await withTaskGroup(of: String?.self) { group in
            group.addTask { await importer.value }
            group.addTask {
                try? await Task.sleep(nanoseconds: 5_000_000_000)
                return nil
            }
            let first = await group.next() ?? nil
            group.cancelAll()
            importer.cancel()
            return first
        }
        if let converted, !converted.isEmpty { return converted }
        return stripTags(source)
    }

    private static func stripTags(_ html: String) -> String {
        var text = html
        for tag in ["script", "style", "head"] {
            while let open = text.range(of: "<\(tag)"),
                  let close = text[open.upperBound...].range(of: "</\(tag)>") {
                text.removeSubrange(open.lowerBound..<close.upperBound)
            }
        }
        var result = ""
        var inTag = false
        for character in text {
            if character == "<" { inTag = true }
            else if character == ">" { inTag = false }
            else if !inTag { result.append(character) }
        }
        let entities = ["&amp;": "&", "&lt;": "<", "&gt;": ">", "&quot;": "\"", "&#39;": "'", "&nbsp;": " "]
        for (entity, replacement) in entities {
            result = result.replacingOccurrences(of: entity, with: replacement)
        }
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
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
        guard let url = urls(in: trimmed).first else { return false }
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
        let instruction = urlHandling.trimmingCharacters(in: .whitespacesAndNewlines)
        if !instruction.isEmpty, Self.isURLOnly(message.text) {
            content += "\n\n[Instruction: \(instruction)]"
        }
        return content
    }

    private func stream() async {
        guard let url = URL(string: baseURL.trimmingCharacters(in: .whitespaces))?
            .appending(path: "chat/completions") else {
            messages.append(Message(role: .assistant, text: "Error: invalid base URL"))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 300

        var payload: [String: Any] = [
            "model": model,
            "stream": true,
            // Always-thinking models (glm-5.x) reject "type"; the budget field sets the level.
            "thinking": ["budget": thinkingBudget],
            "messages": messages.enumerated().map { index, message in
                ["role": message.role.rawValue, "content": apiContent(for: message, isLast: index == messages.count - 1)]
            },
        ]
        if webSearch {
            payload["tools"] = [["type": "web_search", "web_search": ["enable": true, "search_result": true]]]
        }
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        do {
            let (bytes, response) = try await URLSession.shared.bytes(for: request)

            if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
                var body = ""
                for try await line in bytes.lines { body += line }
                throw StreamError(status: http.statusCode, body: body)
            }

            for try await line in bytes.lines {
                try Task.checkCancellation()
                guard line.hasPrefix("data:") else { continue }
                let data = line.dropFirst(5).trimmingCharacters(in: .whitespaces)
                if data == "[DONE]" { break }
                if let delta = Self.decodeDelta(data) {
                    appendToAssistant(delta)
                }
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

    private struct Delta {
        var reasoning = ""
        var content = ""
        var promptTokens: Int?
        var completionTokens: Int?
    }

    private func appendToAssistant(_ delta: Delta) {
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

    private static func decodeDelta(_ string: String) -> Delta? {
        guard let object = try? JSONSerialization.jsonObject(with: Data(string.utf8)) as? [String: Any]
        else { return nil }
        var delta = Delta()
        if let choices = object["choices"] as? [[String: Any]],
           let message = choices.first?["delta"] as? [String: Any] {
            delta.reasoning = message["reasoning_content"] as? String ?? ""
            delta.content = message["content"] as? String ?? ""
        }
        if let usage = object["usage"] as? [String: Any] {
            delta.promptTokens = usage["prompt_tokens"] as? Int
            delta.completionTokens = usage["completion_tokens"] as? Int
        }
        if delta.reasoning.isEmpty && delta.content.isEmpty
            && delta.promptTokens == nil && delta.completionTokens == nil { return nil }
        return delta
    }
}
