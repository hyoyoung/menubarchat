import Foundation

enum PromptComposer {
    private struct AttachmentRef {
        let isWeb: Bool
        let number: Int
    }

    static func isLongPaste(_ text: String) -> Bool {
        text.split(separator: "\n", omittingEmptySubsequences: false).count > 10
    }

    static func apiContent(messages: [Message], urlHandling: String, for message: Message, isLast: Bool) -> String {
        let pages = message.pages.filter { $0.error == nil }
        guard isLast else {
            var content = message.text
            if message.pasteID > 0 {
                content = "[Text ID\(message.pasteID)p (\(firstLine(of: message.text))) — mention \"ID\(message.pasteID)p\" to re-include]"
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
        for ref in mentionedAttachments(in: messages) {
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
        if !instruction.isEmpty, isURLOnly(message.text) || message.pasteID > 0 {
            content += "\n\n[Instruction: \(instruction) — unless the user already asked something specific above]"
        }
        return content
    }

    private static func mentionedAttachments(in messages: [Message]) -> [AttachmentRef] {
        guard let text = messages.last?.text,
              let regex = try? NSRegularExpression(pattern: "ID(\\d+)(p?)")
        else { return [] }
        let range = NSRange(text.startIndex..., in: text)
        return regex.matches(in: text, range: range).compactMap { match in
            guard let number = Range(match.range(at: 1), in: text),
                  let value = Int(text[number])
            else { return nil }
            let isPaste = match.range(at: 2).length > 0
            return AttachmentRef(isWeb: !isPaste, number: value)
        }
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
}
