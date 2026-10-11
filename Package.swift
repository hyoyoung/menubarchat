// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MenuBarChat",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "MenuBarChat",
            path: "Sources/MenuBarChat"
        )
    ]
)
