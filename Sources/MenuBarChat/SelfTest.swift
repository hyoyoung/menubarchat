import AppKit
import Foundation

// CLT-only builds have no importable test runner (XCTest/Testing), so unit
// tests run in-process: `swift run MenuBarChat --selftest` exits 0/1.
enum SelfTest {
    private static var failures = 0

    static func run() async -> Bool {
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
        imageEncoderResize()
        imagePathDetection()
        transcriptWindowing()
        pageExcerpts()
        slashCommandExpansion()
        commandStubbing()
        mathConversion()
        imageAttachmentComposition()
        await stripFirstExtraction()
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
        check(content.contains("[Text ID1p (line 1)]"), "non-last paste -> stub")
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
        check(content.contains("[Page ID2 (example.com)]"), "non-last page -> stub")
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

    private static func stripFirstExtraction() async {
        let good = String(repeating: "x", count: 300)
        check(await PageFetcher.resolvedText(stripped: good) { "IMPORTER-RAN" } == good, "sufficient strip skips importer")
        check(await PageFetcher.resolvedText(stripped: "thin") { good } == good, "thin strip uses importer")
        check(await PageFetcher.resolvedText(stripped: "thin") { nil } == "thin", "importer failure keeps strip")
        check(!PageFetcher.isSufficientText("") && PageFetcher.isSufficientText(good), "sufficiency threshold")
        let navSoup = String(repeating: "   |    |  \n", count: 40) + "NAVER 뉴스 홈"
        check(!PageFetcher.isSufficientText(navSoup), "nav soup insufficient")
        check(PageFetcher.isSufficientText(String(repeating: "real article text ", count: 30)), "real text sufficient")
        check(PageFetcher.cleanedText("  |  |  \n  Hello   world  \n|||\n") == "Hello world", "cleanup drops symbol fragments")
        let giantStyle = "<style>" + String(repeating: ".a{color:red}", count: 60_000) + "</style><p>" + String(repeating: "real body text ", count: 40) + "</p>"
        let strippedGiant = PageFetcher.strippedText(fromHTML: giantStyle)
        check(!strippedGiant.contains("color:red") && strippedGiant.contains("real body text"), "length cut never leaks style blocks")
    }

    private static func imageEncoderResize() {
        guard let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil, pixelsWide: 2000, pixelsHigh: 100,
            bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
            colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0
        ) else { check(false, "encoder rep"); return }
        let image = NSImage(size: NSSize(width: 2000, height: 100))
        image.addRepresentation(rep)
        guard let jpeg = ImageEncoder.jpegData(from: image),
              let decoded = NSBitmapImageRep(data: jpeg) else { check(false, "encoder jpeg"); return }
        check(decoded.pixelsWide == 1568 && decoded.pixelsHigh == 78, "encoder caps to 1568")
        check(ImageEncoder.dataURL(fromJPEG: jpeg).hasPrefix("data:image/jpeg;base64,"), "encoder data url prefix")
    }

    private static func imagePathDetection() {
        check(ImageEncoder.imageFileURL(fromPathString: "/System/Library/CoreServices/DefaultDesktop.heic") != nil, "image path detected")
        check(ImageEncoder.imageFileURL(fromPathString: "/etc/hosts") == nil, "non-image path ignored")
        check(ImageEncoder.imageFileURL(fromPathString: "hello world") == nil, "plain text ignored")
        check(ImageEncoder.imageFileURL(fromPathString: "/nonexistent/folder/cat.png") == nil, "missing file ignored")
        check(ImageEncoder.isImagePathString("/nonexistent/folder/cat.png"), "path shape without file still image-shaped")
    }

    private static func transcriptWindowing() {
        let messages = [
            Message(role: .user, text: "q1"),
            Message(role: .assistant, text: "a1"),
            Message(role: .user, text: "q2"),
            Message(role: .assistant, text: "a2"),
            Message(role: .user, text: "q3"),
        ]
        let transcript = PromptComposer.transcript(messages: messages, urlHandling: "")
        check(transcript.map(\.role) == ["user", "user", "assistant", "user"], "only last assistant reply kept")
        check(transcript.map(\.content) == ["q1", "q2", "a2", "q3"], "users kept in order")

        let urlOnly = Message(role: .user, text: "https://example.com")
        let withURL = [Message(role: .user, text: "q1"), Message(role: .assistant, text: "a1"), urlOnly]
        check(PromptComposer.transcript(messages: withURL, urlHandling: "").map(\.role) == ["user", "user"], "URL-only send drops last reply")

        var imageOnly = Message(role: .user, text: "")
        imageOnly.imageData = Data([1])
        let withImage = [Message(role: .user, text: "q1"), Message(role: .assistant, text: "a1"), imageOnly]
        check(PromptComposer.transcript(messages: withImage, urlHandling: "").map(\.role) == ["user", "user"], "image-only send drops last reply")
    }

    private static func pageExcerpts() {
        let page = { FetchedPage(host: "example.com", text: $0, imageURL: nil, error: nil) }
        let short = String(repeating: "a", count: 1_000)
        let single = PromptComposer.excerpts([page(short)])
        check(single == [short], "short page attaches whole")

        let long = String(repeating: "b", count: 12_000)
        let capped = PromptComposer.excerpts([page(long)])
        check(capped.first?.count == 4_000, "single page capped per page")

        let two = PromptComposer.excerpts([page(long), page(long)])
        check(two.allSatisfy { $0.count == 4_000 }, "two long pages fit budget exactly")

        let tiny = String(repeating: "c", count: 50)
        let many = PromptComposer.excerpts(Array(repeating: page(long), count: 8))
        check(many.allSatisfy { $0.count >= 500 && $0.count <= 2_500 }, "oversized set shrinks proportionally")
        check(PromptComposer.excerpts([page(tiny)]).first == tiny, "tiny page untouched")
    }

    private static func slashCommandExpansion() {
        let commands = [SlashCommand(name: "news", prompt: "digest prompt")]
        check(SlashCommands.expand("/news", commands: commands) == "digest prompt", "slash command expands")
        check(SlashCommands.expand("/news extra input", commands: commands) == "digest prompt\nextra input", "rest appended on new line")
        check(SlashCommands.expand("/foo", commands: commands) == nil, "unknown command untouched")
        check(SlashCommands.expand("plain text", commands: commands) == nil, "non-slash untouched")
        check(SlashCommands.completions(for: "/ne", commands: commands).count == 1, "prefix completion")
        check(SlashCommands.completions(for: "/news extra", commands: commands).isEmpty, "no completion with args")
        let seeded = SettingsStore.defaultCommands
        check(seeded.first?.name == "news", "news command seeded")
        check((seeded.first?.prompt.contains("news.ycombinator.com") ?? false)
            && (seeded.first?.prompt.contains("news.naver.com") ?? false), "seed prompt covers sources")
        check((seeded.first?.prompt.contains("Write the digest in \(SettingsStore.systemLanguageName)") ?? false)
            && (seeded.first?.prompt.hasPrefix("Summarize") ?? false), "seed prompt english with system language")
    }

    private static func commandStubbing() {
        var old = Message(role: .user, text: "Summarize the content from these news sites: A B C D")
        old.commandName = "news"
        let followUp = Message(role: .user, text: "https://example.com")
        let messages = [old, Message(role: .assistant, text: "digest"), followUp]
        let stubbed = PromptComposer.apiContent(messages: messages, urlHandling: "", for: old, isLast: false)
        check(stubbed.contains("[Command: /news]"), "old command message stubbed")
        check(!stubbed.contains("Summarize the content"), "command prompt body dropped from later requests")

        var fresh = Message(role: .user, text: "Summarize everything now")
        fresh.commandName = "news"
        let asLast = PromptComposer.apiContent(messages: [Message(role: .user, text: "q"), Message(role: .assistant, text: "a"), fresh], urlHandling: "", for: fresh, isLast: true)
        check(asLast.contains("Summarize everything now"), "last command prompt kept full")

        var bundle = Message(role: .user, text: "x")
        bundle.viaCommand = true
        bundle.commandName = "news"
        bundle.pageBundleID = 5
        bundle.pages = [FetchedPage(id: 0, host: "a.com", text: "A", imageURL: nil, error: nil)]
        let bundleStub = PromptComposer.apiContent(messages: [bundle, Message(role: .assistant, text: "r"), Message(role: .user, text: "next")], urlHandling: "", for: bundle, isLast: false)
        check(bundleStub.contains("[Command: /news]\n\n[Sources ID5]"), "bundle stub single line")
        check(!bundleStub.contains("[Page"), "no per-page stubs for command messages")

        let bundleLast = PromptComposer.apiContent(messages: [bundle, Message(role: .assistant, text: "r"), Message(role: .user, text: "next")], urlHandling: "", for: bundle, isLast: true)
        check(bundleLast.contains("[Source — a.com]"), "last command sources labeled by host")
    }

    private static func mathConversion() {
        check(MathFormatter.unicodeMath(in: "$f(x) = \\sum_i v_i (k_i^\\top x)$") == "f(x) = Σᵢ vᵢ (kᵢᵀ x)", "sum with subscripts converts")
        check(MathFormatter.unicodeMath(in: "$\\alpha + \\frac{a}{b} \\leq \\pi$") == "α + (a)/(b) ≤ π", "greek and frac convert")
        let unknown = MathFormatter.unicodeMath(in: "$\\unknowncmd{x} + y$")
        check(unknown.hasPrefix("\\unknowncmd") && unknown.hasSuffix("x + y"), "unknown command preserved")
        check(MathFormatter.unicodeMath(in: "costs $5 and $6 total") == "costs $5 and $6 total", "currency untouched")
        check(MathFormatter.unicodeMath(in: "no math **bold** here") == "no math **bold** here", "non-math untouched")
    }

    private static func imageAttachmentComposition() {
        var earlier = Message(role: .user, text: "what is this?")
        earlier.imageID = 2
        earlier.imageData = Data([0xFF, 0xD8, 0xFF])
        var last = Message(role: .user, text: "ID2i 다시 보여줘")
        last.imageID = 3
        last.imageData = Data([0x01])
        let messages = [earlier, Message(role: .assistant, text: "a cat"), last]

        let nonLast = PromptComposer.apiContent(messages: messages, urlHandling: "", for: earlier, isLast: false)
        check(nonLast.contains("[Image ID2i]"), "image stub for past message")

        check(PromptComposer.needsImageParts(messages: messages), "needs parts on image mention")
        let parts = PromptComposer.imageParts(messages: messages, urlHandling: "")
        check(parts.count == 3, "text + two image parts")
        check(parts[0]["type"] as? String == "text", "first part is text")
        let json = (try? JSONSerialization.data(withJSONObject: parts, options: .withoutEscapingSlashes)).flatMap { String(data: $0, encoding: .utf8) } ?? ""
        check(json.contains("data:image/jpeg;base64,"), "image data url part")

        check(!PromptComposer.needsImageParts(messages: [Message(role: .user, text: "hi")]), "no parts without image")
    }
}
