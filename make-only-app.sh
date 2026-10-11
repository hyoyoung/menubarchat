#!/bin/sh
set -e
build_output=$(swift build -c release 2>&1) || { printf '%s\n' "$build_output"; exit 1; }
printf '%s\n' "$build_output"
warnings=$(printf '%s\n' "$build_output" | grep 'warning:' | grep -v 'CommandLineTools/Developer' || true)
if [ -n "$warnings" ]; then
    echo "빌드 경고 발견 — 수정 후 다시 시도하세요:" >&2
    printf '%s\n' "$warnings" >&2
    exit 1
fi
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
