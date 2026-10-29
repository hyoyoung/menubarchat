import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var chat: ChatModel
    @EnvironmentObject private var settings: SettingsStore
    @FocusState private var focused: Bool

    private func scrollToBottom(proxy: ScrollViewProxy, chat: ChatModel) {
        // Run after the layout pass: scrolling against mid-growth content
        // (fetch previews landing one by one) overshoots into blank space.
        DispatchQueue.main.async {
            guard let last = chat.messages.last else { return }
            // Pin to real, materialized rows only — targeting the synthetic
            // placeholder before it exists makes ScrollViewReader guess an
            // offset and jump far off (usually way up).
            let emptyAssistant = last.role == .assistant && last.text.isEmpty
            if chat.isStreaming && emptyAssistant {
                proxy.scrollTo("placeholder", anchor: .bottom)
            } else {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        }
    }

    private func handleImageDrop(_ urls: [URL]) -> Bool {
        guard let url = urls.first,
              ImageEncoder.imageExtensions.contains(url.pathExtension.lowercased()),
              let image = NSImage(contentsOf: url)
        else { return false }
        guard chat.supportsImageInput,
              let jpeg = ImageEncoder.jpegData(from: image)
        else {
            chat.showPasteNotice()
            return true
        }
        chat.stageImage(jpeg)
        return true
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Text("Chat")
                    .font(.headline)
                if chat.isStreaming {
                    ProgressView()
                        .controlSize(.small)
                }
                Spacer()
                Button {
                    chat.clear()
                } label: {
                    Image(systemName: "trash")
                }
                .buttonStyle(.plain)
                .help("Clear conversation")
                Button {
                    chat.showsSettings.toggle()
                } label: {
                    Image(systemName: chat.showsSettings ? "gearshape.fill" : "gearshape")
                }
                .buttonStyle(.plain)
                .help("Settings")
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            if chat.showsSettings {
                SettingsView()
            }

            Divider()

            ScrollViewReader { proxy in
                GeometryReader { scrollGeometry in
                    ScrollView {
                        if chat.messages.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "ellipsis.bubble")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                                Text("Ask anything")
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 160)
                        } else {
                            LazyVStack(alignment: .leading, spacing: 8) {
                                ForEach(chat.messages) { message in
                                    MessageView(
                                        message: message,
                                        copiedMessageID: chat.copiedMessageID,
                                        hoveredMessageID: chat.hoveredMessageID
                                    )
                                        .equatable()
                                        .id(message.id)
                                }
                                if chat.isStreaming,
                                   chat.messages.last?.role != .assistant
                                   || (chat.messages.last?.text ?? "").isEmpty {
                                    HStack(spacing: 8) {
                                        ProgressView()
                                            .controlSize(.small)
                                        if chat.isFetchingPage {
                                            Text(chat.fetchingPageCount > 1
                                                 ? "페이지 \(min(chat.messages.last?.pages.count ?? 0, chat.fetchingPageCount))/\(chat.fetchingPageCount) 가져오는 중…"
                                                 : "페이지 가져오는 중…")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        } else {
                                            Text("답변 생성 중…")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer(minLength: 0)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color(nsColor: .controlBackgroundColor))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding(.trailing, 48)
                                    .id("placeholder")
                                }
                            }
                            .padding(14)
                            // Bottom marker: re-enables following once the
                            // viewport actually reaches the content bottom.
                            Color.clear
                                .frame(height: 0)
                                .background(
                                    GeometryReader { marker in
                                        Color.clear
                                            .onChange(of: marker.frame(in: .global).minY) { _, markerY in
                                                if markerY <= scrollGeometry.frame(in: .global).maxY + 40 {
                                                    if !chat.followsBottom {
                                                        chat.followsBottom = true
                                                        // Absorb the tolerance gap so later per-delta
                                                        // pins share the same anchor.
                                                        scrollToBottom(proxy: proxy, chat: chat)
                                                    }
                                                }
                                            }
                                    }
                                )
                        }
                    }
                    // No rubber-band when content fits the viewport — kills
                    // the blank-space flash past the bottom edge.
                    .scrollBounceBehavior(.basedOnSize)
                    .onChange(of: chat.messages) { _, _ in
                        if chat.followsBottom {
                            scrollToBottom(proxy: proxy, chat: chat)
                        }
                    }
                    .onChange(of: chat.pendingBottomPin) { _, requested in
                        guard requested, chat.followsBottom else { return }
                        chat.pendingBottomPin = false
                        // Let the re-shown hierarchy commit its first
                        // layout before pinning.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            scrollToBottom(proxy: proxy, chat: chat)
                        }
                    }
                    .overlay(alignment: .bottom) {
                        if !chat.followsBottom && !chat.messages.isEmpty {
                            Button {
                                scrollToBottom(proxy: proxy, chat: chat)
                                chat.followsBottom = true
                            } label: {
                                Image(systemName: "arrow.down")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                    .padding(6)
                                    .background(.thinMaterial, in: Circle())
                            }
                            .buttonStyle(.plain)
                            .padding(.bottom, 8)
                            .help("맨 아래로 이동")
                        }
                    }
                    .dropDestination(for: URL.self) { urls, _ in
                        handleImageDrop(urls)
                    }
                }
            }

            Divider()

            if let notice = chat.pasteNotice {
                Text(notice)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 14)
                    .padding(.top, 6)
            }

            if let staged = chat.stagedPaste {
                HStack(spacing: 8) {
                    Image(systemName: "doc.text")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\((staged.split(separator: "\n", omittingEmptySubsequences: true).first ?? "").prefix(60)) · \(staged.split(separator: "\n", omittingEmptySubsequences: false).count)줄 · 전송 시 첨부")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    Spacer(minLength: 8)
                    Button {
                        chat.clearStaged()
                    } label: {
                        Image(systemName: "trash")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .buttonStyle(.plain)
                    .help("붙여넣기 항목 삭제")
                    Button {
                        chat.unstageToDraft()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .buttonStyle(.plain)
                    .help("초안으로 되돌리기")
                }
                .padding(.horizontal, 14)
                .padding(.top, 8)
            }

            if let imageData = chat.stagedImage, let nsImage = NSImage(data: imageData) {
                HStack(spacing: 8) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 36)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    Text("이미지 · 전송 시 첨부")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer(minLength: 8)
                    Button {
                        chat.clearStagedImage()
                    } label: {
                        Image(systemName: "trash")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .buttonStyle(.plain)
                    .help("이미지 첨부 삭제")
                }
                .padding(.horizontal, 14)
                .padding(.top, 8)
            }

            if !chat.queuedMessages.isEmpty {
                VStack(spacing: 6) {
                    HStack {
                        Text("대기 메시지 \(chat.queuedMessages.count)개")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Button("모두 지우기") { chat.clearQueued() }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .buttonStyle(.plain)
                            .keyboardShortcut(.delete, modifiers: [.option, .command])
                    }
                    ForEach(chat.queuedMessages) { queued in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 6, height: 6)
                            Text(queued.text)
                                .font(.system(.callout, design: .monospaced))
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Spacer(minLength: 8)
                            Button {
                                chat.removeQueued(queued)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .buttonStyle(.plain)
                            .help("대기 메시지 삭제")
                            Button {
                                chat.unqueueToDraft(queued)
                            } label: {
                                Image(systemName: "pencil")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .buttonStyle(.plain)
                            .help("초안으로 되돌리기")
                            Button("지금 보내기 ↵") {
                                chat.sendQueuedNow(queued)
                            }
                            .font(.caption)
                            .buttonStyle(.borderless)
                            .disabled(!chat.isStreaming)
                        }
                    }
                    Divider()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
            }

            HStack(alignment: .bottom, spacing: 8) {
                TextField("Message", text: $chat.draft, axis: .vertical)
                    .textFieldStyle(.plain)
                    .lineLimit(1...5)
                    .focused($focused)
                    .onKeyPress(.tab, phases: .down) { _ in
                        guard let first = SlashCommands.completions(for: chat.draft, commands: settings.availableCommands).first
                        else { return .ignored }
                        chat.applyCommand(first)
                        return .handled
                    }
                    .onChange(of: chat.draft) { _, _ in
                        chat.convertDraftImage()
                    }
                    .onSubmit {
                        if !chat.queuedMessages.isEmpty,
                           chat.draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            chat.stop()
                        } else {
                            chat.send()
                        }
                    }
                    // The backing field editor inserts file paths on drops
                    // by default; claiming the drop here prevents that.
                    .dropDestination(for: URL.self) { urls, _ in
                        handleImageDrop(urls)
                    }

                Button {
                    if chat.isStreaming {
                        chat.stop()
                    } else {
                        chat.send()
                    }
                } label: {
                    Image(systemName: chat.isStreaming ? "stop.circle.fill" : "arrow.up.circle.fill")
                        .font(.title2)
                }
                .buttonStyle(.plain)
                .disabled(!chat.isStreaming
                    && chat.draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .overlay(alignment: .bottom) {
                let completions = SlashCommands.completions(for: chat.draft, commands: settings.availableCommands)
                if !completions.isEmpty, !chat.showsSettings {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(completions) { command in
                            Button {
                                chat.applyCommand(command)
                            } label: {
                                Text("/" + command.name)
                                    .font(.callout.monospaced())
                                    .foregroundStyle(.primary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
                    .offset(y: -46)
                }
            }
            .padding(14)
        }
        .onAppear {
            NSApp.activate(ignoringOtherApps: true)
            focused = true
        }
        .onExitCommand {
            if chat.showsSettings { chat.showsSettings = false }
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsStore

    private let modelPresets = ["glm-5.3-flash", "glm-5.3", "glm-4.6"]
    private let thinkingBudgets = ["low", "medium", "high", "max"]
    private let languagePresets = ["Korean", "English", "Japanese", "Chinese", "Spanish"]

    private var languageSelection: Binding<String> {
        Binding(
            get: { languagePresets.contains(settings.appLanguage) ? settings.appLanguage : "" },
            set: { settings.appLanguage = $0 }
        )
    }

    private var modelSelection: Binding<String> {
        Binding(
            get: { modelPresets.contains(settings.model) ? settings.model : "" },
            set: { settings.model = $0 }
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("API key")
                SecureField("Z.AI API key", text: $settings.apiKey)
            }
            HStack {
                Text("Base URL")
                TextField("https://api.z.ai/api/coding/paas/v4", text: $settings.baseURL)
            }
            HStack {
                Text("Model")
                Spacer()
                Picker("", selection: modelSelection) {
                    ForEach(modelPresets, id: \.self) { Text($0) }
                    Text("Custom…").tag("")
                }
                .pickerStyle(.menu)
                .labelsHidden()
            }
            if modelSelection.wrappedValue.isEmpty {
                TextField("Model name", text: $settings.model)
            }
            HStack {
                Text("Thinking")
                Spacer()
                Picker("", selection: $settings.thinkingBudget) {
                    ForEach(thinkingBudgets, id: \.self) { Text($0) }
                }
                .pickerStyle(.menu)
                .labelsHidden()
            }
            Toggle("Web search", isOn: $settings.webSearch)
                .toggleStyle(.switch)
            HStack {
                Text("URL handling")
                TextField("http/https default handling", text: $settings.urlHandling)
            }
            HStack {
                Text("Language")
                Spacer()
                Picker("", selection: languageSelection) {
                    ForEach(languagePresets, id: \.self) { Text($0) }
                    Text("Custom…").tag("")
                }
                .pickerStyle(.menu)
                .labelsHidden()
            }
            if languageSelection.wrappedValue.isEmpty {
                TextField("Language name", text: $settings.appLanguage)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Commands")
                ForEach(SettingsStore.builtinCommands) { command in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Text("/" + command.name)
                                .font(.callout.monospaced())
                            Text("Built-in")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(nsColor: .quaternaryLabelColor), in: Capsule())
                            Spacer()
                        }
                        Text(command.prompt)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                    }
                }
                ForEach($settings.commands) { $command in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            TextField("name", text: $command.name)
                                .frame(maxWidth: 120)
                            Button {
                                settings.commands.removeAll { $0.id == command.id }
                            } label: {
                                Image(systemName: "trash")
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(.secondary)
                        }
                        TextField("prompt", text: $command.prompt, axis: .vertical)
                            .lineLimit(2...5)
                    }
                }
                Button {
                    settings.commands.append(SlashCommand(name: "", prompt: ""))
                } label: {
                    Label("Add command", systemImage: "plus")
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
            }
        }
        .textFieldStyle(.roundedBorder)
        .font(.callout)
        .padding(.horizontal, 14)
        .padding(.bottom, 12)
    }
}

struct AboutView: View {
    let close: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "ellipsis.bubble")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            Text("MenuBarChat")
                .font(.title2.bold())
            Text("Menu Bar + Chat")
                .font(.callout)
                .foregroundStyle(.secondary)
            Text("A chat with Z.AI GLM that lives in the macOS menu bar.")
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
            Divider()
                .frame(width: 160)
            Text("Version 1.0 · SwiftUI + SwiftPM · no Xcode")
                .font(.caption)
                .foregroundStyle(.secondary)
            Button("Close", action: close)
                .buttonStyle(.bordered)
                .keyboardShortcut(.defaultAction)
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MessageView: View, Equatable {
    let message: Message
    var copiedMessageID: UUID?
    var hoveredMessageID: UUID?
    @EnvironmentObject private var chat: ChatModel

    // Equality must only touch stored properties: SwiftUI runs it outside
    // the update pass, where @EnvironmentObject is not injected and reading
    // it traps (crash MenuBarChat-2026-10-17-165436).
    static func == (lhs: MessageView, rhs: MessageView) -> Bool {
        lhs.message == rhs.message
            && lhs.copiedMessageID == rhs.copiedMessageID
            && lhs.hoveredMessageID == rhs.hoveredMessageID
    }

    nonisolated static func markdown(_ text: String) -> AttributedString {
        var source = MathFormatter.unicodeMath(in: text)
        // Collapse 3+ consecutive newlines to a single blank line.
        if let regex = try? NSRegularExpression(pattern: #"\n{3,}"#) {
            source = regex.stringByReplacingMatches(
                in: source, range: NSRange(source.startIndex..., in: source),
                withTemplate: "\n\n"
            )
        }
        var options = AttributedString.MarkdownParsingOptions()
        options.interpretedSyntax = .inlineOnlyPreservingWhitespace
        var attr = (try? AttributedString(markdown: source, options: options)) ?? AttributedString(source)
        // The spec promises no strikethrough, and GFM ~~ pairs can span
        // newlines and strike unrelated lines, so the intent is dropped.
        for run in attr.runs {
            if let intent = run.inlinePresentationIntent, intent.contains(.strikethrough) {
                attr[run.range].inlinePresentationIntent = intent.subtracting(.strikethrough)
            }
        }
        return attr
    }

    private var reasoningLines: [String] {
        message.reasoning.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    }

    private var needsFold: Bool {
        reasoningLines.count > 5 || message.reasoning.count > 100
    }

    private var foldLabel: String {
        let suffix: String
        if let index = chat.messages.firstIndex(where: { $0.id == message.id }),
           let userIndex = chat.messages[..<index].lastIndex(where: { $0.role == .user }) {
            let userMessage = chat.messages[userIndex]
            if userMessage.viaCommand, userMessage.pageBundleID > 0 {
                suffix = ", ID\(userMessage.pageBundleID)"
            } else if let page = userMessage.pages.first(where: { $0.error == nil }), page.id > 0 {
                suffix = ", ID\(page.id)"
            } else if userMessage.pasteID > 0 {
                suffix = ", ID\(userMessage.pasteID)p"
            } else {
                suffix = ""
            }
        } else {
            suffix = ""
        }
        return (message.isReasoningExpanded ? "Less" : "More") + suffix
    }

    private var displayedReasoning: String {
        guard needsFold, !message.isReasoningExpanded else { return message.reasoning }
        return reasoningLines.prefix(5).joined(separator: "\n")
    }

    var body: some View {
        HStack {
            if message.role == .user { Spacer(minLength: 48) }
            VStack(alignment: .leading, spacing: 6) {
                if !message.reasoning.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(displayedReasoning)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        if needsFold {
                            Button(foldLabel) {
                                if let index = chat.messages.firstIndex(where: { $0.id == message.id }) {
                                    chat.messages[index].isReasoningExpanded.toggle()
                                }
                            }
                            .font(.caption)
                            .italic()
                            .foregroundStyle(.secondary)
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(nsColor: .controlBackgroundColor).opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                if message.role == .user,
                   let nsImage = message.cachedImage ?? message.imageData.flatMap({ NSImage(data: $0) }) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                if !message.text.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        if message.viaCommand, let name = message.commandName,
                           // Fold by visual size: the /news prompt is a
                           // single long paragraph with no newlines.
                           message.text.split(separator: "\n", omittingEmptySubsequences: false).count > 5
                               || message.text.count > 100 {
                            // Display-only fold: the full text still goes to
                            // the request; paste classification is untouched.
                            HStack(spacing: 10) {
                                Image(systemName: "terminal")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                    .frame(width: 40, height: 40)
                                    .background(Color(nsColor: .quaternaryLabelColor))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("/" + name)
                                        .font(.callout)
                                    Text("명령 · \(message.text.split(separator: "\n", omittingEmptySubsequences: false).count)줄")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                    Text(message.text)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(5)
                                }
                                Spacer(minLength: 0)
                            }
                            if message.isTextExpanded {
                                Text(message.text)
                            }
                            Button((message.isTextExpanded ? "Less" : "More")
                                + (message.pageBundleID > 0 ? ", ID\(message.pageBundleID)" : "")) {
                                if let index = chat.messages.firstIndex(where: { $0.id == message.id }) {
                                    chat.messages[index].isTextExpanded.toggle()
                                }
                            }
                            .font(.caption)
                            .italic()
                            .foregroundStyle(.secondary)
                            .buttonStyle(.plain)
                        } else if message.role == .user,
                                  // Attachment pastes plus any visually
                                  // long user text share the fold card.
                                  message.pasteID > 0
                                      || message.text.split(separator: "\n", omittingEmptySubsequences: false).count > 5
                                      || message.text.count > 100 {
                            HStack(spacing: 10) {
                                Image(systemName: "doc.text")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                    .frame(width: 40, height: 40)
                                    .background(Color(nsColor: .quaternaryLabelColor))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(message.text.split(separator: "\n", omittingEmptySubsequences: true).first.map(String.init) ?? "")
                                        .font(.callout)
                                        .lineLimit(1)
                                    Text("붙여넣은 텍스트 · \(message.text.split(separator: "\n", omittingEmptySubsequences: false).count)줄")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer(minLength: 0)
                            }
                            if message.isTextExpanded {
                                Text(message.text)
                            }
                            Button((message.isTextExpanded ? "Less" : "More")
                                + (message.pasteID > 0 ? ", ID\(message.pasteID)p" : "")) {
                                if let index = chat.messages.firstIndex(where: { $0.id == message.id }) {
                                    chat.messages[index].isTextExpanded.toggle()
                                }
                            }
                            .font(.caption)
                            .italic()
                            .foregroundStyle(.secondary)
                            .buttonStyle(.plain)
                        } else if message.role == .assistant {
                            SelectableTextView(attributed: message.cachedMarkdown ?? Self.markdown(message.text))
                        } else {
                            Text(message.text)
                        }
                        if message.role == .assistant {
                            HStack {
                                Spacer(minLength: 0)
                                Button {
                                    chat.copyAnswer(message)
                                } label: {
                                    Image(systemName: copiedMessageID == message.id ? "checkmark" : "doc.on.doc")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        message.role == .user
                            ? Color.accentColor.opacity(0.2)
                            : Color(nsColor: .controlBackgroundColor)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(alignment: .bottomTrailing) {
                        // Overlay keeps the bubble size stable while hovering.
                        if message.role == .user,
                           hoveredMessageID == message.id || copiedMessageID == message.id {
                            Button {
                                chat.copyAnswer(message)
                            } label: {
                                Image(systemName: copiedMessageID == message.id ? "checkmark" : "doc.on.doc")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .padding(4)
                                    .background(Color(nsColor: .controlBackgroundColor).opacity(0.9))
                                    .clipShape(Circle())
                            }
                            .buttonStyle(.plain)
                            .padding(4)
                        }
                    }
                    .onHover { hovering in
                        if message.role == .user {
                            chat.hoveredMessageID = hovering ? message.id : nil
                        }
                    }
                }
                if let prompt = message.promptTokens, let completion = message.completionTokens {
                    Text("↑\(prompt) ↓\(completion)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                if message.viaCommand, !message.pages.isEmpty {
                    SourceListCard(bundleID: message.pageBundleID, pages: message.pages)
                } else {
                    ForEach(message.pages, id: \.host) { page in
                        PagePreview(page: page)
                    }
                }
            }
            if message.role == .assistant { Spacer(minLength: 48) }
        }
    }
}

// AppKit-backed selectable text for assistant replies: native drag
// selection and Cmd+C without SwiftUI Text's selection layout path
// (which drops frames on long attributed strings).
struct SelectableTextView: NSViewRepresentable {
    let attributed: AttributedString

    func makeNSView(context: Context) -> NSTextView {
        let storage = NSTextStorage()
        let container = NSTextContainer(
            containerSize: CGSize(width: 0, height: CGFloat.greatestFiniteMagnitude)
        )
        container.widthTracksTextView = true
        container.lineFragmentPadding = 0
        let layoutManager = NSLayoutManager()
        storage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(container)
        let textView = NSTextView(frame: CGRect.zero, textContainer: container)
        textView.isEditable = false
        textView.isSelectable = true
        textView.drawsBackground = false
        textView.textContainerInset = NSSize.zero
        textView.textColor = .labelColor
        // Plain-looking links: normal text color, no underline (click still
        // opens the browser; bold/italic remain the only visual cue).
        textView.linkTextAttributes = [
            .foregroundColor: NSColor.labelColor,
            .underlineStyle: 0
        ]
        return textView
    }

    func updateNSView(_ textView: NSTextView, context: Context) {
        textView.textStorage?.setAttributedString(NSAttributedString(attributed))
        textView.textColor = .labelColor
        // Streaming deltas swap the storage constantly; without an explicit
        // invalidation SwiftUI keeps stale frames (blank until scrolled).
        textView.needsLayout = true
        textView.needsDisplay = true
    }

    func sizeThatFits(_ proposal: ProposedViewSize, nsView: NSTextView, context: Context) -> CGSize? {
        guard let width = proposal.width, width > 0,
              let container = nsView.textContainer,
              let layoutManager = nsView.layoutManager
        else { return nil }
        container.size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        layoutManager.ensureLayout(for: container)
        let used = layoutManager.usedRect(for: container)
        return CGSize(width: width, height: ceil(used.height))
    }
}

struct SourceListCard: View {
    let bundleID: Int
    let pages: [FetchedPage]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("ID\(bundleID) · \(pages.count) sources")
                .font(.caption2)
                .foregroundStyle(.secondary)
            ForEach(pages, id: \.host) { page in
                if let error = page.error {
                    Text("\(page.host) — \(error)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text(page.host)
                        .font(.caption)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct PagePreview: View {
    let page: FetchedPage

    private var firstLine: String {
        page.text.split(separator: "\n", omittingEmptySubsequences: true).first.map(String.init) ?? ""
    }

    var body: some View {
        Group {
            if let error = page.error {
                Label(error, systemImage: "exclamationmark.triangle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(nsColor: .controlBackgroundColor).opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                HStack(spacing: 10) {
                    AsyncImage(url: page.imageURL) { phase in
                        if let image = phase.image {
                            image.resizable().scaledToFill()
                        } else {
                            Color(nsColor: .quaternaryLabelColor)
                        }
                    }
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("ID\(page.id) · \(page.host)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(firstLine)
                            .font(.callout)
                            .lineLimit(2)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(nsColor: .controlBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}
