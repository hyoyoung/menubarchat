import Foundation

enum PromptComposer {
    private struct AttachmentRef {
        enum Kind { case web, paste, image }
        let kind: Kind
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
            if message.imageID > 0 {
                content += "\n\n[Image ID\(message.imageID)i — mention \"ID\(message.imageID)i\" to re-include]"
            }
            return content
        }
        var content = message.text
        if message.pasteID > 0 {
            content = "[Pasted text ID\(message.pasteID)p]\n\(message.text)"
        }
        if message.imageID > 0 {
            content = "[Image ID\(message.imageID)i]\n\(message.text)"
        }
        for page in pages {
            content += "\n\n[Page ID\(page.id) — \(page.host)]\n\(page.text)"
        }
        var includedPages = Set(pages.map(\.id))
        var includedPastes: Set<Int> = [message.pasteID]
        for ref in mentionedAttachments(in: messages) {
            switch ref.kind {
            case .web:
                guard !includedPages.contains(ref.number),
                      let page = messages.flatMap(\.pages).first(where: { $0.error == nil && $0.id == ref.number })
                else { continue }
                includedPages.insert(ref.number)
                content += "\n\n[Page ID\(page.id) — \(page.host)]\n\(page.text)"
            case .paste:
                guard !includedPastes.contains(ref.number),
                      let source = messages.first(where: { $0.pasteID == ref.number })
                else { continue }
                includedPastes.insert(ref.number)
                content += "\n\n[Pasted text ID\(ref.number)p]\n\(source.text)"
            case .image:
                continue
            }
        }
        let instruction = urlHandling.trimmingCharacters(in: .whitespacesAndNewlines)
        if !instruction.isEmpty, isURLOnly(message.text) || message.pasteID > 0 {
            content += "\n\n[Instruction: \(instruction) — unless the user already asked something specific above]"
        }
        return content
    }

    static func needsImageParts(messages: [Message]) -> Bool {
        guard let last = messages.last, last.role == .user else { return false }
        if last.imageData != nil { return true }
        let mentionedImages = Set(mentionedAttachments(in: messages).filter { $0.kind == .image }.map(\.number))
        return messages.contains { $0.imageID != 0 && mentionedImages.contains($0.imageID) }
    }

    static func imageParts(messages: [Message], urlHandling: String) -> [[String: Any]] {
        guard let message = messages.last, message.role == .user else { return [] }
        var text = apiContent(messages: messages, urlHandling: urlHandling, for: message, isLast: true)
        var parts: [[String: Any]] = []
        var includedImages: Set<Int> = []
        if message.imageID > 0, let data = message.imageData {
            includedImages.insert(message.imageID)
            parts.append(imagePart(data))
        }
        for ref in mentionedAttachments(in: messages) where ref.kind == .image {
            guard !includedImages.contains(ref.number),
                  let source = messages.first(where: { $0.imageID == ref.number }),
                  let data = source.imageData
            else { continue }
            includedImages.insert(ref.number)
            text += "\n\n[Image ID\(ref.number)i re-included]"
            parts.append(imagePart(data))
        }
        return [["type": "text", "text": text]] + parts
    }

    private static func imagePart(_ data: Data) -> [String: Any] {
        ["type": "image_url", "image_url": ["url": ImageEncoder.dataURL(fromJPEG: data)]]
    }

    private static func mentionedAttachments(in messages: [Message]) -> [AttachmentRef] {
        guard let text = messages.last?.text,
              let regex = try? NSRegularExpression(pattern: "ID(\\d+)([pi]?)")
        else { return [] }
        let range = NSRange(text.startIndex..., in: text)
        return regex.matches(in: text, range: range).compactMap { match in
            guard let number = Range(match.range(at: 1), in: text),
                  let value = Int(text[number])
            else { return nil }
            let letter = Range(match.range(at: 2), in: text).map { String(text[$0]) } ?? ""
            let kind: AttachmentRef.Kind = letter == "p" ? .paste : (letter == "i" ? .image : .web)
            return AttachmentRef(kind: kind, number: value)
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
