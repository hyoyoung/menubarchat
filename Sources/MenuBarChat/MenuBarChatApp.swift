import AppKit
import SwiftUI

final class ChatPanel: NSPanel {
    override var canBecomeKey: Bool { true }
}

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let chat = ChatModel()
    private var statusItem: NSStatusItem!
    private var panel: ChatPanel!
    private var aboutPanel: ChatPanel!
    private let menu = NSMenu()
    private var pasteMonitor: Any?

    func applicationWillFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        installMainMenu()

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.button?.image = NSImage(systemSymbolName: "ellipsis.bubble", accessibilityDescription: "MenuBarChat")
        statusItem.button?.target = self
        statusItem.button?.action = #selector(statusItemClicked(_:))
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])

        let about = menu.addItem(withTitle: "About MenuBarChat", action: #selector(showAbout(_:)), keyEquivalent: "")
        about.target = self
        menu.addItem(.separator())
        menu.addItem(withTitle: "Quit MenuBarChat", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")

        let content = ContentView()
            .environmentObject(chat)
            .environmentObject(chat.settings)
            .frame(width: 400, height: 520)
        panel = ChatPanel(contentViewController: NSHostingController(rootView: content))
        panel.styleMask = [.titled, .resizable, .fullSizeContentView, .nonactivatingPanel]
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.isReleasedWhenClosed = false
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.setFrame(NSRect(x: 0, y: 0, width: 400, height: 520), display: false)

        aboutPanel = ChatPanel(contentViewController: NSHostingController(
            rootView: AboutView { [weak self] in self?.aboutPanel?.orderOut(nil) }
        ))
        aboutPanel.styleMask = [.titled, .fullSizeContentView, .nonactivatingPanel]
        aboutPanel.titleVisibility = .hidden
        aboutPanel.titlebarAppearsTransparent = true
        aboutPanel.isReleasedWhenClosed = false
        aboutPanel.level = .floating
        aboutPanel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        aboutPanel.setFrame(NSRect(x: 0, y: 0, width: 300, height: 340), display: false)

        pasteMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.interceptPaste(event) ?? event
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        if let pasteMonitor { NSEvent.removeMonitor(pasteMonitor) }
    }

    // SwiftUI (macOS) offers no paste interception on TextField, so ⌘V is
    // classified before insertion: non-text paste is rejected with a notice,
    // long text is staged as an attachment instead of entering the field.
    private func interceptPaste(_ event: NSEvent) -> NSEvent? {
        guard event.window === panel,
              !chat.showsSettings,
              event.modifierFlags.contains(.command),
              (event.charactersIgnoringModifiers ?? "").lowercased() == "v"
        else { return event }
        guard let text = NSPasteboard.general.string(forType: .string) else {
            chat.showPasteNotice()
            return nil
        }
        if PromptComposer.isLongPaste(text) {
            chat.stagePaste(text)
            return nil
        }
        return event
    }

    // Without a main menu, Edit key equivalents (Cmd+C/V/X/A/Z) never reach the text field.
    private func installMainMenu() {
        let editMenu = NSMenu(title: "Edit")
        editMenu.addItem(withTitle: "Undo", action: Selector(("undo:")), keyEquivalent: "z")
        editMenu.addItem(withTitle: "Redo", action: Selector(("redo:")), keyEquivalent: "Z")
        editMenu.addItem(.separator())
        editMenu.addItem(withTitle: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
        editMenu.addItem(withTitle: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        editMenu.addItem(withTitle: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        editMenu.addItem(withTitle: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        let editItem = NSMenuItem()
        editItem.submenu = editMenu
        let mainMenu = NSMenu()
        mainMenu.addItem(editItem)
        NSApp.mainMenu = mainMenu
    }

    @objc private func statusItemClicked(_ sender: NSStatusBarButton) {
        if let event = NSApp.currentEvent, event.type == .rightMouseUp {
            statusItem.menu = menu
            statusItem.button?.performClick(sender)
            statusItem.menu = nil
        } else {
            togglePanel()
        }
    }

    private func showPanelBelowIcon(_ panel: NSPanel) {
        // Activate before ordering front: when the app is inactive (another
        // app focused) the panel's front placement can otherwise be ignored.
        NSApp.activate(ignoringOtherApps: true)
        if let iconFrame = statusItem.button?.window?.frame {
            let width = panel.frame.width
            let screen = NSScreen.screens.first { iconFrame.midX >= $0.frame.minX && iconFrame.midX <= $0.frame.maxX }
                ?? NSScreen.main
            let visible = screen?.visibleFrame ?? .zero
            let x = min(max(iconFrame.midX - width / 2, visible.minX), visible.maxX - width)
            panel.setFrameOrigin(NSPoint(x: x, y: iconFrame.minY - panel.frame.height - 8))
        }
        panel.makeKeyAndOrderFront(nil)
    }

    private func togglePanel() {
        // Hide only when truly visible; a visible-flagged but occluded panel
        // is re-shown below the icon instead of consuming the click to hide.
        if panel.isVisible && panel.occlusionState.contains(.visible) {
            panel.orderOut(nil)
            chat.showsSettings = false
            return
        }
        showPanelBelowIcon(panel)
    }

    @objc private func showAbout(_ sender: Any?) {
        showPanelBelowIcon(aboutPanel)
    }
}

