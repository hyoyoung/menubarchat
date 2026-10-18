import Combine
import Foundation

struct SlashCommand: Codable, Equatable, Identifiable {
    var id = UUID()
    var name: String
    var prompt: String
}

enum SlashCommands {
    static func applyingLanguage(_ text: String, language: String) -> String {
        text.replacingOccurrences(of: "{language}", with: language)
    }
    // Expansion is exact-match on the first draft token; prefix matching is
    // reserved for the autocomplete dropdown.
    static func matchedCommand(in draft: String, commands: [SlashCommand]) -> SlashCommand? {
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.hasPrefix("/") else { return nil }
        let token = trimmed.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).first.map(String.init) ?? ""
        return commands.first { "/" + $0.name.trimmingCharacters(in: .whitespaces) == token }
    }

    static func expand(_ draft: String, commands: [SlashCommand]) -> String? {
        guard let command = matchedCommand(in: draft, commands: commands) else { return nil }
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        let token = trimmed.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true).first.map(String.init) ?? ""
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
    @Published var appLanguage: String { didSet { UserDefaults.standard.set(appLanguage, forKey: "appLanguage") } }
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
        urlHandling = defaults.string(forKey: "urlHandling") ?? "summarize it in {language}"
        appLanguage = defaults.string(forKey: "appLanguage") ?? Self.systemLanguageName
        if let data = defaults.data(forKey: "commands"),
           let saved = try? JSONDecoder().decode([SlashCommand].self, from: data) {
            commands = saved
        } else {
            commands = []
        }
    }

    // User commands join the built-ins; on a name clash the builtin wins.
    nonisolated static func mergedCommands(builtin: [SlashCommand], user: [SlashCommand]) -> [SlashCommand] {
        let builtinNames = Set(builtin.map { $0.name.trimmingCharacters(in: .whitespaces) })
        return builtin + user.filter { !builtinNames.contains($0.name.trimmingCharacters(in: .whitespaces)) }
    }

    var availableCommands: [SlashCommand] {
        Self.mergedCommands(builtin: Self.builtinCommands, user: commands)
    }

    // Built-in commands live in code only (never stored), so app updates
    // always take effect — stored copies of the same name are shadowed.
    nonisolated static let builtinCommands = [
        SlashCommand(
            name: "news",
            prompt: """
            Summarize the news from these sites: \
            https://news.ycombinator.com/news \
            https://www.bbc.com/news \
            https://edition.cnn.com/us \
            https://news.naver.com/ — \
            pick the top 15 STEM stories (title + one-line summary + source); \
            for major or trending ones, add 2-3 lines of detail. \
            Follow with the top 15 general news stories, one line each — \
            skip typical news without mentioning exclusions. \
            Below are previous digests; do not repeat stories already \
            covered there: {previous} \
            Write the digest in {language}.
            """
        ),
        // Local command: intercepted in send(); the prompt is unused.
        SlashCommand(name: "previous-news", prompt: ""),
    ]

    nonisolated static var systemLanguageName: String {
        let code = Locale.current.language.languageCode?.identifier ?? "en"
        return Locale(identifier: "en_US").localizedString(forLanguageCode: code) ?? "English"
    }
}
