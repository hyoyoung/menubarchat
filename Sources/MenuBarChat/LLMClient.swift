import Foundation

struct StreamError: LocalizedError {
    let status: Int
    let body: String

    var errorDescription: String? {
        "HTTP \(status): \(String(body.prefix(300)))"
    }
}

private struct InvalidBaseURL: LocalizedError {
    var errorDescription: String? { "invalid base URL" }
}

enum LLMClient {
    struct Delta {
        var reasoning = ""
        var content = ""
        var promptTokens: Int?
        var completionTokens: Int?
    }

    static func stream(
        baseURL: String,
        apiKey: String,
        model: String,
        thinkingBudget: String,
        webSearch: Bool,
        messages: [(role: String, content: String)]
    ) -> AsyncThrowingStream<Delta, Error> {
        AsyncThrowingStream { continuation in
            let task = Task {
                do {
                    guard let url = URL(string: baseURL.trimmingCharacters(in: .whitespaces))?
                        .appending(path: "chat/completions") else {
                        throw InvalidBaseURL()
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
                        "messages": messages.map { ["role": $0.role, "content": $0.content] },
                    ]
                    if webSearch {
                        payload["tools"] = [["type": "web_search", "web_search": ["enable": true, "search_result": true]]]
                    }
                    request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

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
                        if let delta = decodeDelta(data) {
                            continuation.yield(delta)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
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
