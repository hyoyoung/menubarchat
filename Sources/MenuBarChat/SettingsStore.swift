import Combine
import Foundation

struct SlashCommand: Codable, Equatable, Identifiable {
    var id = UUID()
    var name: String
    var prompt: String
}

enum SlashCommands {
    // Expansion is exact-match on the first draft token; prefix matching is
    // reserved for the autocomplete dropdown.
    static func expand(_ draft: String, commands: [SlashCommand]) -> String? {
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.hasPrefix("/") else { return nil }
        let token = trimmed.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).first.map(String.init) ?? ""
        guard let command = commands.first(where: { "/" + $0.name.trimmingCharacters(in: .whitespaces) == token })
        else { return nil }
        let rest = trimmed.dropFirst(token.count).trimmingCharacters(in: .whitespacesAndNewlines)
        return rest.isEmpty ? command.prompt : command.prompt + "\n" + rest
    }

    static func completions(for draft: String, commands: [SlashCommand]) -> [SlashCommand] {
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.hasPrefix("/"), !trimmed.contains(" ") else { return [] }
        let prefix = String(trimmed.dropFirst())
        return commands.filter { $0.name.hasPrefix(prefix) }
    }
}

@MainActor
final class SettingsStore: ObservableObject {
    @Published var apiKey: String { didSet { UserDefaults.standard.set(apiKey, forKey: "apiKey") } }
    @Published var baseURL: String { didSet { UserDefaults.standard.set(baseURL, forKey: "baseURL") } }
    @Published var model: String { didSet { UserDefaults.standard.set(model, forKey: "model") } }
    @Published var thinkingBudget: String { didSet { UserDefaults.standard.set(thinkingBudget, forKey: "thinkingBudget") } }
    @Published var webSearch: Bool { didSet { UserDefaults.standard.set(webSearch, forKey: "webSearch") } }
    @Published var urlHandling: String { didSet { UserDefaults.standard.set(urlHandling, forKey: "urlHandling") } }
    @Published var commands: [SlashCommand] {
        didSet { UserDefaults.standard.set(try? JSONEncoder().encode(commands), forKey: "commands") }
    }

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
        if let data = defaults.data(forKey: "commands"),
           let saved = try? JSONDecoder().decode([SlashCommand].self, from: data) {
            commands = saved
        } else {
            commands = Self.defaultCommands
        }
    }

    // Seeded only when nothing is stored yet; user edits and deletions win.
    nonisolated static let defaultCommands = [
        SlashCommand(
            name: "news",
            prompt: """
            다음 뉴스 사이트들의 내용을 종합해 주세요: \
            https://news.ycombinator.com/news \
            https://www.bbc.com/news \
            https://edition.cnn.com/us \
            https://news.naver.com/ — \
            기술 뉴스 상위 15개(제목 + 한 줄 요약 + 출처 사이트)를 뽑고, \
            이어서 놓치면 안 되는 중요하거나 이색적인 비기술 사건을 별도 \
            섹션으로 정리해 주세요.
            """
        ),
    ]

    private static var systemLanguageName: String {
        let code = Locale.current.language.languageCode?.identifier ?? "en"
        return Locale(identifier: "en_US").localizedString(forLanguageCode: code) ?? "English"
    }
}
