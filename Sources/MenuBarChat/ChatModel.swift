import Foundation

struct Message: Identifiable, Equatable {
    let id = UUID()
    let role: Role
    var text: String
    var reasoning = ""
    var promptTokens: Int?
    var completionTokens: Int?

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
    @Published var showsSettings = false

    @Published var apiKey: String { didSet { UserDefaults.standard.set(apiKey, forKey: "apiKey") } }
    @Published var baseURL: String { didSet { UserDefaults.standard.set(baseURL, forKey: "baseURL") } }
    @Published var model: String { didSet { UserDefaults.standard.set(model, forKey: "model") } }

    private var streamTask: Task<Void, Never>?

    init() {
        let defaults = UserDefaults.standard
        let env = ProcessInfo.processInfo.environment
        apiKey = defaults.string(forKey: "apiKey")
            ?? env["ZAI_API_KEY"] ?? env["Z_AI_API_KEY"] ?? ""
        baseURL = defaults.string(forKey: "baseURL") ?? "https://api.z.ai/api/coding/paas/v4"
        model = defaults.string(forKey: "model") ?? "glm-5.3-flash"
    }

    func send() {
        let prompt = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !prompt.isEmpty, !isStreaming else { return }
        draft = ""
        messages.append(Message(role: .user, text: prompt))
        isStreaming = true
        showsSettings = false

        streamTask = Task {
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

        let payload: [String: Any] = [
            "model": model,
            "stream": true,
            // Always-thinking models (glm-5.x) reject "type"; the budget field sets the level.
            "thinking": ["budget": "low"],
            "messages": messages.map { ["role": $0.role.rawValue, "content": $0.text] },
        ]
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
