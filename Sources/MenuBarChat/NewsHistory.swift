import Foundation

// Ring of recent /news digests (newest first). Persisted as JSON in
// Application Support; entries older than 24h are dropped on load.
enum NewsHistory {
    struct Entry: Codable, Equatable {
        var date: Date
        var text: String
    }

    static let fileURL: URL = {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("MenuBarChat", isDirectory: true)
        try? FileManager.default.createDirectory(at: support, withIntermediateDirectories: true)
        return support.appendingPathComponent("news-history.json")
    }()

    // Drop entries older than 24h, keep the newest 5 (newest-first order).
    static func trimmed(entries: [Entry], now: Date) -> [Entry] {
        let fresh = entries.filter { now.timeIntervalSince($0.date) <= 24 * 3600 }
        return Array(fresh.prefix(5))
    }

    static func load(now: Date = Date()) -> [Entry] {
        guard let data = try? Data(contentsOf: fileURL),
              let entries = try? JSONDecoder().decode([Entry].self, from: data)
        else { return [] }
        let trimmed = trimmed(entries: entries, now: now)
        if trimmed.count != entries.count {
            save(trimmed)
        }
        return trimmed
    }

    static func append(_ text: String, now: Date = Date()) {
        var entries = load(now: now)
        entries.insert(Entry(date: now, text: text), at: 0)
        save(trimmed(entries: entries, now: now))
    }

    static func save(_ entries: [Entry]) {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    static func clear() {
        save([])
    }

    // Prompt injection: newest digests joined, or "none" on an empty ring.
    static func previousContext(entries: [Entry], limit: Int = 2) -> String {
        guard !entries.isEmpty else { return "none" }
        return entries.prefix(limit).map(\.text).joined(separator: "\n---\n")
    }
}
