import AppKit
import WebKit

struct FetchedPage: Equatable {
    struct Link: Equatable {
        let title: String
        let url: String
    }

    var id = 0
    let host: String
    let text: String
    let imageURL: URL?
    let error: String?
    var links: [Link] = []
}

enum PageFetcher {
    static func urls(in text: String) -> [URL] {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let range = NSRange(text.startIndex..., in: text)
        return (detector?.matches(in: text, range: range) ?? [])
            .compactMap(\.url)
            .filter { $0.scheme == "http" || $0.scheme == "https" }
    }

    private static let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Safari/605.1.15"

    static func fetchPage(_ url: URL) async -> FetchedPage {
        guard let host = url.host() else {
            return FetchedPage(host: url.absoluteString, text: "", imageURL: nil, error: "invalid URL")
        }
        if let videoID = youtubeVideoID(of: url) {
            return await fetchTranscript(pageURL: url, host: host, videoID: videoID)
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 15
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
                return FetchedPage(host: host, text: "", imageURL: nil, error: "HTTP \(http.statusCode)")
            }
            let html = String(data: data, encoding: .utf8) ?? ""
            let text = await Self.plainText(fromHTML: html, url: url)
            guard !text.isEmpty else {
                return FetchedPage(host: host, text: "", imageURL: nil, error: "no content")
            }
            return FetchedPage(
                host: host,
                text: String(text.prefix(20_000)),
                imageURL: ogImage(in: html),
                error: nil,
                links: anchors(inHTML: html, base: url)
            )
        } catch {
            let reason = (error as? URLError)?.code == .timedOut ? "timeout" : "network error"
            return FetchedPage(host: host, text: "", imageURL: nil, error: reason)
        }
    }

    struct CaptionTrack {
        let baseURL: String
        let languageCode: String
        let isAuto: Bool
    }

    static func youtubeVideoID(of url: URL) -> String? {
        guard let host = url.host()?.lowercased() else { return nil }
        if host == "youtu.be" {
            let id = url.path().dropFirst()
            return id.isEmpty ? nil : String(id)
        }
        guard host == "youtube.com" || host == "www.youtube.com" || host == "m.youtube.com" else { return nil }
        guard let v = URLComponents(url: url, resolvingAgainstBaseURL: false)?
            .queryItems?.first(where: { $0.name == "v" })?.value, !v.isEmpty
        else { return nil }
        return v
    }

    static func captionTracks(inHTML html: String) -> [CaptionTrack] {
        guard let start = html.range(of: "\"captionTracks\":["),
              let end = html[start.upperBound...].firstRange(of: "]")
        else { return [] }
        let json = "[\(html[start.upperBound..<end.lowerBound])]"
        guard let data = json.data(using: .utf8),
              let tracks = (try? JSONSerialization.jsonObject(with: data)) as? [[String: Any]]
        else { return [] }
        return tracks.compactMap { track in
            guard let baseURL = track["baseUrl"] as? String else { return nil }
            return CaptionTrack(
                baseURL: baseURL,
                languageCode: track["languageCode"] as? String ?? "",
                isAuto: (track["kind"] as? String) == "asr"
            )
        }
    }

    static func selectCaptionTrack(_ tracks: [CaptionTrack], preferredLanguage: String) -> CaptionTrack? {
        for group in [tracks.filter { !$0.isAuto }, tracks.filter { $0.isAuto }] {
            if group.isEmpty { continue }
            if let hit = group.first(where: { $0.languageCode == preferredLanguage }) { return hit }
            if let hit = group.first(where: { $0.languageCode.hasPrefix("en") }) { return hit }
            return group.first
        }
        return nil
    }

    static func transcript(fromJSON3 data: Data) -> String {
        guard let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let events = object["events"] as? [[String: Any]]
        else { return "" }
        var lines: [String] = []
        for event in events {
            guard let segments = event["segs"] as? [[String: Any]] else { continue }
            let line = segments.compactMap { $0["utf8"] as? String }
                .joined()
                .trimmingCharacters(in: .whitespacesAndNewlines)
            if !line.isEmpty { lines.append(line) }
        }
        return lines.joined(separator: "\n")
    }

    private static func metadataPage(html: String, host: String) -> FetchedPage {
        let title = metaContent("og:title", in: html) ?? ""
        let description = metaContent("og:description", in: html) ?? ""
        guard !title.isEmpty || !description.isEmpty else {
            return FetchedPage(host: host, text: "", imageURL: ogImage(in: html), error: "no content")
        }
        let text = "Video metadata (no captions): \(title)\n\(description)"
        return FetchedPage(host: host, text: String(text.prefix(20_000)), imageURL: ogImage(in: html), error: nil)
    }

    private static func fetchTranscript(pageURL: URL, host: String, videoID: String) async -> FetchedPage {
        func failure(_ reason: String, _ html: String = "") -> FetchedPage {
            FetchedPage(host: host, text: "", imageURL: ogImage(in: html), error: reason)
        }
        do {
            var pageRequest = URLRequest(url: pageURL)
            pageRequest.timeoutInterval = 15
            pageRequest.setValue(userAgent, forHTTPHeaderField: "User-Agent")
            let (data, response) = try await URLSession.shared.data(for: pageRequest)
            if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
                return failure("HTTP \(http.statusCode)")
            }
            let html = String(data: data, encoding: .utf8) ?? ""
            let tracks = captionTracks(inHTML: html)
            let preferred = Locale.current.language.languageCode?.identifier ?? "en"
            guard let track = selectCaptionTrack(tracks, preferredLanguage: preferred) else {
                return metadataPage(html: html, host: host)
            }
            guard let timedURL = URL(string: track.baseURL + "&fmt=json3") else {
                return failure("invalid URL", html)
            }
            var request = URLRequest(url: timedURL)
            request.timeoutInterval = 15
            request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
            let (transcriptData, transcriptResponse) = try await URLSession.shared.data(for: request)
            if let http = transcriptResponse as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
                return failure("HTTP \(http.statusCode)", html)
            }
            let text = transcript(fromJSON3: transcriptData)
            guard !text.isEmpty else { return metadataPage(html: html, host: host) }
            return FetchedPage(
                host: host,
                text: String(text.prefix(20_000)),
                imageURL: ogImage(in: html),
                error: nil
            )
        } catch {
            let reason = (error as? URLError)?.code == .timedOut ? "timeout" : "network error"
            return failure(reason)
        }
    }

    static func metaContent(_ property: String, in html: String) -> String? {
        guard let tag = html.range(of: property),
              let open = html[tag.upperBound...].range(of: "content=\"")?.upperBound,
              let close = html[open...].range(of: "\"")
        else { return nil }
        return String(html[open..<close.lowerBound])
    }

    private static func ogImage(in html: String) -> URL? {
        metaContent("og:image", in: html).flatMap(URL.init(string:))
    }

    // Strip-first: the tag strip is effectively instant and good enough for
    // normal pages; only thin results (JS shells) pay the WebKit importer,
    // which can stall its caller and therefore runs behind a short cap.
    // Real-content view of a stripped page: collapse runs of spaces and drop
    // fragments with no letters/digits, so nav chrome (pipes, spacing, bare
    // markup leftovers) collapses to almost nothing while prose survives.
    static func cleanedText(_ text: String) -> String {
        text.split(whereSeparator: \.isNewline)
            .map { $0.split(separator: " ").joined(separator: " ") }
            .filter { $0.contains(where: { $0.isLetter || $0.isNumber }) }
            .joined(separator: "\n")
    }

    static func isSufficientText(_ text: String) -> Bool {
        let total = text.filter { !$0.isWhitespace }.count
        guard total > 0 else { return false }
        let real = cleanedText(text).filter { !$0.isWhitespace }.count
        return real >= 200 && Double(real) >= 0.5 * Double(total)
    }

    static func resolvedText(stripped: String, runImporter: @escaping () async -> String?) async -> String {
        if isSufficientText(stripped) { return cleanedText(stripped) }
        if let converted = await runImporter(), isSufficientText(converted) {
            return cleanedText(converted)
        }
        return cleanedText(stripped)
    }

    // Two-phase strip: block removal must see the full document — a length
    // cut inside a giant <style> orphans the closing tag and leaks CSS into
    // the "content" (observed with 4.8MB CNN pages). Only the remaining
    // text is length-capped afterwards.
    static func strippedText(fromHTML html: String) -> String {
        var text = html
        for tag in ["script", "style", "head"] {
            while let open = text.range(of: "<\(tag)"),
                  let close = text[open.upperBound...].range(of: "</\(tag)>") {
                text.removeSubrange(open.lowerBound..<close.upperBound)
            }
        }
        return scanTags(String(text.prefix(500_000)))
    }

    // Invisible-to-humans elements (tiny fonts, CSS/attribute hiding) are a
    // prompt-injection vector — drop the whole element before extraction.
    static func removingHiddenElements(_ html: String) -> String {
        let pattern = #"<([a-zA-Z][a-zA-Z0-9]*)([^>]*(?:style="[^"]*(?:display\s*:\s*none|visibility\s*:\s*hidden|opacity\s*:\s*0(?:\.0+)?|font-size\s*:\s*[0-8](?:\.\d+)?px)|text-\[[0-8]px\]|aria-hidden="true"|\shidden(?:\s|>))[^>]*)>.*?</\1>"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else {
            return html
        }
        return regex.stringByReplacingMatches(
            in: html, range: NSRange(html.startIndex..., in: html), withTemplate: ""
        )
    }

    private static func plainText(fromHTML html: String, url: URL) async -> String {
        let stripped = strippedText(fromHTML: removingHiddenElements(html))
        return await resolvedText(stripped: stripped, runImporter: {
            await withTaskGroup(of: String?.self) { group in
                group.addTask { await renderInnerText(of: url) }
                group.addTask {
                    try? await Task.sleep(nanoseconds: 3_000_000_000)
                    return nil
                }
                let first = await group.next() ?? nil
                group.cancelAll()
                return first
            }
        })
    }

    // JS-executing fallback for React-style shells: a real WKWebView load,
    // polled for rendered body text. The caller's 3s race bounds the wait.
    @MainActor
    private static func renderInnerText(of url: URL) async -> String? {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        for _ in 0..<50 {
            if Task.isCancelled { return nil }
            try? await Task.sleep(nanoseconds: 100_000_000)
            // Drop invisible nodes (tiny fonts, hidden) — same injection
            // vector as the static filter, resolved via computed styles.
            await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
                webView.evaluateJavaScript("""
                document.querySelectorAll('body *').forEach(el => {
                    const s = getComputedStyle(el);
                    const size = parseFloat(s.fontSize) || 16;
                    if (s.visibility === 'hidden' || parseFloat(s.opacity) === 0 || size < 9) el.remove();
                });
                """, completionHandler: { _, _ in continuation.resume() })
            }
            let text: String? = await withCheckedContinuation { continuation in
                webView.evaluateJavaScript("document.body.innerText", completionHandler: { result, _ in
                    continuation.resume(returning: result as? String)
                })
            }
            if let text, text.filter({ !$0.isWhitespace }).count > 500 {
                return text
            }
        }
        return nil
    }

    // Anchor (title, URL) pairs for digest linking: external-host targets
    // only — same-host nav/self links crowd actual stories out of the cap.
    static func filteredAnchors(raw: [(text: String, href: String)], base: URL) -> [FetchedPage.Link] {
        var seen = Set<String>()
        var result: [FetchedPage.Link] = []
        let pageHost = base.host()?.lowercased()
        for pair in raw {
            let title = pair.text
                .split(whereSeparator: \.isNewline).first.map(String.init)?
                .trimmingCharacters(in: .whitespaces) ?? ""
            guard !title.isEmpty, !pair.href.hasPrefix("#") else { continue }
            guard let url = URL(string: pair.href, relativeTo: base)?.absoluteURL,
                  let scheme = url.scheme?.lowercased(),
                  scheme == "http" || scheme == "https",
                  let urlHost = url.host()?.lowercased()
            else { continue }
            if urlHost == pageHost { continue }
            let key = url.absoluteString
            guard seen.insert(key).inserted else { continue }
            result.append(FetchedPage.Link(title: title, url: key))
            if result.count >= 80 { break }
        }
        return result
    }

    static func anchors(inHTML html: String, base: URL) -> [FetchedPage.Link] {
        var raw: [(text: String, href: String)] = []
        if let regex = try? NSRegularExpression(
            pattern: #"<a\b[^>]*href="([^"]+)"[^>]*>(.*?)</a>"#,
            options: [.dotMatchesLineSeparators]
        ) {
            regex.enumerateMatches(in: html, range: NSRange(html.startIndex..., in: html)) { match, _, _ in
                guard let match,
                      let href = Range(match.range(at: 1), in: html).map({ String(html[$0]) }),
                      let body = Range(match.range(at: 2), in: html).map({ String(html[$0]) })
                else { return }
                raw.append((text: strippedText(fromHTML: body), href: href))
            }
        }
        return filteredAnchors(raw: raw, base: base)
    }

    private static func scanTags(_ html: String) -> String {
        var result = ""
        var inTag = false
        for character in html {
            if character == "<" { inTag = true }
            else if character == ">" { inTag = false }
            else if !inTag { result.append(character) }
        }
        let entities = ["&amp;": "&", "&lt;": "<", "&gt;": ">", "&quot;": "\"", "&#39;": "'", "&nbsp;": " "]
        for (entity, replacement) in entities {
            result = result.replacingOccurrences(of: entity, with: replacement)
        }
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
