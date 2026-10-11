import Foundation

// CLT-only builds have no importable test runner (XCTest/Testing), so unit
// tests run in-process: `swift run MenuBarChat --selftest` exits 0/1.
enum SelfTest {
    private static var failures = 0

    static func run() -> Bool {
        failures = 0
        nonLastPasteBecomesStub()
        lastPasteIncludesFullText()
        nonLastPageBecomesStub()
        lastPageIncludesFullText()
        mentionReincludesPasteWithoutDuplicate()
        mentionReincludesPage()
        instructionAttachedToURLOnlyMessage()
        instructionAttachedToLongPaste()
        instructionSkippedForPlainMessage()
        emptyInstructionNeverAttached()
        print(failures == 0 ? "selftest: all passed" : "selftest: \(failures) failure(s)")
        return failures == 0
    }

    private static func check(_ condition: Bool, _ name: String) {
        if condition {
            print("ok   \(name)")
        } else {
            failures += 1
            print("FAIL \(name)")
        }
    }

    private static var longPaste: String {
        (1...12).map { "line \($0)" }.joined(separator: "\n")
    }

    private static func pasteMessage(_ text: String, id: Int) -> Message {
        var message = Message(role: .user, text: text)
        message.pasteID = id
        return message
    }

    private static func pageMessage(_ text: String, pageID: Int) -> Message {
        var page = FetchedPage(host: "example.com", text: "PAGE BODY", imageURL: nil, error: nil)
        page.id = pageID
        var message = Message(role: .user, text: text)
        message.pages = [page]
        return message
    }

    private static func content(_ message: Message, messages: [Message], isLast: Bool, urlHandling: String = "") -> String {
        PromptComposer.apiContent(messages: messages, urlHandling: urlHandling, for: message, isLast: isLast)
    }

    private static func nonLastPasteBecomesStub() {
        let first = pasteMessage(longPaste, id: 1)
        let content = content(first, messages: [first, Message(role: .assistant, text: "ok"), Message(role: .user, text: "next")], isLast: false)
        check(content.contains("[Text ID1p (line 1) — mention \"ID1p\" to re-include]"), "non-last paste -> stub")
        check(!content.contains("line 12"), "non-last paste hides full text")
    }

    private static func lastPasteIncludesFullText() {
        let first = pasteMessage(longPaste, id: 1)
        let content = content(first, messages: [first], isLast: true)
        check(content.hasPrefix("[Pasted text ID1p]\n"), "last paste -> full-text tag")
        check(content.contains("line 12"), "last paste includes body")
    }

    private static func nonLastPageBecomesStub() {
        let first = pageMessage("check this", pageID: 2)
        let content = content(first, messages: [first, Message(role: .assistant, text: "ok")], isLast: false)
        check(content.contains("[Page ID2 (example.com) — mention \"ID2\" to re-include]"), "non-last page -> stub")
        check(!content.contains("PAGE BODY"), "non-last page hides body")
    }

    private static func lastPageIncludesFullText() {
        let first = pageMessage("check this", pageID: 2)
        let content = content(first, messages: [first], isLast: true)
        check(content.contains("[Page ID2 — example.com]\nPAGE BODY"), "last page includes body")
    }

    private static func mentionReincludesPasteWithoutDuplicate() {
        let first = pasteMessage(longPaste, id: 1)
        let last = Message(role: .user, text: "summarize ID1p")
        let content = content(last, messages: [first, Message(role: .assistant, text: "ok"), last], isLast: true)
        check(content.components(separatedBy: "[Pasted text ID1p]").count - 1 == 1, "paste mention re-included once")
        check(content.contains(longPaste), "paste mention includes body")
    }

    private static func mentionReincludesPage() {
        let first = pageMessage("check this", pageID: 2)
        let last = Message(role: .user, text: "what did ID2 say")
        let content = content(last, messages: [first, Message(role: .assistant, text: "ok"), last], isLast: true)
        check(content.contains("[Page ID2 — example.com]\nPAGE BODY"), "page mention re-included")
    }

    private static func instructionAttachedToURLOnlyMessage() {
        let last = Message(role: .user, text: "https://example.com")
        let content = content(last, messages: [last], isLast: true, urlHandling: "summarize it in Korean")
        check(content.contains("[Instruction: summarize it in Korean — unless the user already asked something specific above]"), "URL-only -> instruction")
    }

    private static func instructionAttachedToLongPaste() {
        let last = pasteMessage(longPaste, id: 1)
        let content = content(last, messages: [last], isLast: true, urlHandling: "summarize it in Korean")
        check(content.contains("[Instruction: summarize it in Korean"), "long paste -> instruction")
    }

    private static func instructionSkippedForPlainMessage() {
        let last = Message(role: .user, text: "hello there")
        let content = content(last, messages: [last], isLast: true, urlHandling: "summarize it in Korean")
        check(!content.contains("[Instruction:"), "plain message -> no instruction")
    }

    private static func emptyInstructionNeverAttached() {
        let last = Message(role: .user, text: "https://example.com")
        let content = content(last, messages: [last], isLast: true, urlHandling: "   ")
        check(!content.contains("[Instruction:"), "empty instruction -> none")
    }
}
