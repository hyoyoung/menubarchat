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
        youtubeVideoIDExtraction()
        captionTrackSelection()
        transcriptAssembly()
        metaTagExtraction()
        strikethroughStripped()
        boldSurvivesStrikeStrip()
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

    private static func youtubeVideoIDExtraction() {
        let watch = URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")!
        let short = URL(string: "https://youtu.be/dQw4w9WgXcQ")!
        let foreign = URL(string: "https://example.com/watch?v=abc")!
        let search = URL(string: "https://youtube.com/results?search_query=x")!
        check(PageFetcher.youtubeVideoID(of: watch) == "dQw4w9WgXcQ", "watch URL id")
        check(PageFetcher.youtubeVideoID(of: short) == "dQw4w9WgXcQ", "youtu.be id")
        check(PageFetcher.youtubeVideoID(of: foreign) == nil, "non-youtube nil")
        check(PageFetcher.youtubeVideoID(of: search) == nil, "no v param nil")
    }

    private static func captionTrackSelection() {
        let html = #"x "captionTracks":[{"baseUrl":"https://t/ko","languageCode":"ko","kind":"asr"},{"baseUrl":"https://t/en","languageCode":"en"}] y"#
        let tracks = PageFetcher.captionTracks(inHTML: html)
        check(tracks.count == 2, "tracks parsed")
        check(tracks[0].isAuto && tracks[0].languageCode == "ko", "auto flag parsed")
        check(PageFetcher.selectCaptionTrack(tracks, preferredLanguage: "ko")?.baseURL == "https://t/en", "manual over auto")
        check(PageFetcher.selectCaptionTrack(tracks, preferredLanguage: "en")?.baseURL == "https://t/en", "preferred en manual")
        let manualKO = [
            PageFetcher.CaptionTrack(baseURL: "https://t/kom", languageCode: "ko", isAuto: false),
            PageFetcher.CaptionTrack(baseURL: "https://t/en", languageCode: "en", isAuto: false),
        ]
        check(PageFetcher.selectCaptionTrack(manualKO, preferredLanguage: "ko")?.baseURL == "https://t/kom", "preferred ko manual")
        check(PageFetcher.selectCaptionTrack([], preferredLanguage: "ko") == nil, "no tracks nil")
    }

    private static func transcriptAssembly() {
        let json = #"{"events":[{"segs":[{"utf8":"hello "},{"utf8":"world"}]},{"segs":[{"utf8":"\n"}]},{"segs":[{"utf8":"second line"}]}]}"#
        check(PageFetcher.transcript(fromJSON3: Data(json.utf8)) == "hello world\nsecond line", "json3 assembly")
    }

    private static func metaTagExtraction() {
        let html = #"<meta property="og:title" content="My Video"><meta property="og:description" content="A great video">"#
        check(PageFetcher.metaContent("og:title", in: html) == "My Video", "og:title")
        check(PageFetcher.metaContent("og:description", in: html) == "A great video", "og:description")
        check(PageFetcher.metaContent("og:image", in: html) == nil, "missing tag nil")
    }

    private static func strikethroughStripped() {
        let attr = MessageView.markdown("a ~~b\nc~~ d")
        let struck = attr.runs.contains { $0.inlinePresentationIntent?.contains(.strikethrough) == true }
        check(!struck, "multiline ~~ pair -> no strike")
        check(String(attr.characters) == "a b\nc d", "strike delimiters consumed")
    }

    private static func boldSurvivesStrikeStrip() {
        let attr = MessageView.markdown("**굵게** ~~x~~")
        let bold = attr.runs.contains { $0.inlinePresentationIntent?.contains(.stronglyEmphasized) == true }
        let struck = attr.runs.contains { $0.inlinePresentationIntent?.contains(.strikethrough) == true }
        check(bold && !struck, "bold preserved, strike stripped")
    }
}
