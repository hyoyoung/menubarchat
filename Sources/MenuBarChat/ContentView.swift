import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var chat: ChatModel
    @FocusState private var focused: Bool

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
                                MessageView(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding(14)
                    }
                }
                .onChange(of: chat.messages) { _, _ in
                    if let last = chat.messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }

            Divider()

            HStack(alignment: .bottom, spacing: 8) {
                TextField("Message", text: $chat.draft, axis: .vertical)
                    .textFieldStyle(.plain)
                    .lineLimit(1...5)
                    .focused($focused)
                    .onSubmit { chat.send() }

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
    @EnvironmentObject private var chat: ChatModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SecureField("API key", text: $chat.apiKey)
            TextField("Base URL (OpenAI-compatible)", text: $chat.baseURL)
            TextField("Model", text: $chat.model)
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

struct MessageView: View {
    let message: Message

    var body: some View {
        HStack {
            if message.role == .user { Spacer(minLength: 48) }
            VStack(alignment: .leading, spacing: 6) {
                if !message.reasoning.isEmpty {
                    Text(message.reasoning)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(nsColor: .controlBackgroundColor).opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                if !message.text.isEmpty {
                    Text(message.text)
                        .textSelection(.enabled)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            message.role == .user
                                ? Color.accentColor.opacity(0.2)
                                : Color(nsColor: .controlBackgroundColor)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                if let prompt = message.promptTokens, let completion = message.completionTokens {
                    Text("↑\(prompt) ↓\(completion)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            if message.role == .assistant { Spacer(minLength: 48) }
        }
    }
}
