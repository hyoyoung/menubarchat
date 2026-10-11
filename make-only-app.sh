#!/bin/sh
set -e
swift build -c release
mkdir -p build/MenuBarChat.app/Contents/MacOS
cp .build/release/MenuBarChat build/MenuBarChat.app/Contents/MacOS/MenuBarChat
cat > build/MenuBarChat.app/Contents/Info.plist <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key><string>MenuBarChat</string>
    <key>CFBundleIdentifier</key><string>com.example.menubarchat</string>
    <key>CFBundleName</key><string>MenuBarChat</string>
    <key>CFBundlePackageType</key><string>APPL</string>
    <key>LSUIElement</key><true/>
</dict>
</plist>
EOF
echo "Built build/MenuBarChat.app"
