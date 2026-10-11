# MenuBarChat

A macOS menu bar app for chatting with Z.AI GLM models, with
token-by-token streaming. No Xcode required — builds with Swift Package Manager
and the Command Line Tools.

## Requirements

- macOS 14+
- Xcode Command Line Tools: `xcode-select --install`

## Run (development)

```sh
swift run
```

The chat bubble icon appears in the menu bar. Click it to open the panel;
right-click it for About and Quit.

## Configure

Click the gear icon in the panel:

- **API key** — your Z.AI API key (from https://z.ai)
- **Base URL** — `https://api.z.ai/api/coding/paas/v4` (default; GLM Coding Plan
  quota). Use `https://api.z.ai/api/paas/v4` instead if your key is a
  pay-as-you-go API key.
- **Model** — e.g. `glm-5.3-flash` (default), `glm-5.3`, `glm-4.6` — or a
  custom name via "Custom…"
- **Thinking level** — `low`, `medium`, `high` (default), `max` — sent as the
  API's `thinking.budget`. GLM-5.3 models cannot disable thinking.
- **Web search** — off by default; adds Z.AI's built-in `web_search` tool so
  answers cite web sources. Keep it off to save tokens and latency.

The Z.AI API is OpenAI-compatible, so other endpoints still work if you change
the base URL. Settings persist in UserDefaults; if no key is saved, the
`ZAI_API_KEY` environment variable is used as a fallback (picked up when
launching via `swift run`).

Note: if you already saved settings from an earlier build pointed at another
provider, update them in the gear panel or run
`defaults delete MenuBarChat` (or `com.example.menubarchat` for the bundled
app) and relaunch.

## Build a standalone app

```sh
./make-only-app.sh
open build/MenuBarChat.app
```

This compiles a release binary and wraps it into `MenuBarChat.app` with an
`Info.plist` (`LSUIElement` keeps it out of the Dock). The app is unsigned,
which is fine for local use; distribution or App Store builds would need
Xcode's signing tools.

## Layout

- `Sources/MenuBarChat/MenuBarChatApp.swift` — status item, chat panel,
  right-click About/Quit menu
- `Sources/MenuBarChat/ChatModel.swift` — conversation state, SSE streaming
  over `URLSession.bytes`
- `Sources/MenuBarChat/ContentView.swift` — chat UI, settings, message bubbles
