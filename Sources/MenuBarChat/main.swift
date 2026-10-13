import AppKit

if CommandLine.arguments.contains("--selftest") {
    exit(await SelfTest.run() ? 0 : 1)
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
