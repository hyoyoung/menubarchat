#!/bin/bash
# openspec → 앱 빌드 파이프라인
# 스펙 상태를 점검한 뒤 make-only-app.sh를 호출해 앱을 빌드한다.
set -euo pipefail
cd "$(dirname "$0")"

SPEC_DIR="openspec/specs"
CHANGES_DIR="openspec/changes"

echo "== OpenSpec 스펙 점검 =="

if [ ! -d "$SPEC_DIR" ]; then
    echo "오류: $SPEC_DIR 이(가) 없습니다." >&2
    exit 1
fi

fail=0
for spec in "$SPEC_DIR"/*/spec.md; do
    [ -e "$spec" ] || { echo "오류: 스펙 파일을 찾을 수 없습니다." >&2; exit 1; }
    name=$(basename "$(dirname "$spec")")
    reqs=$(grep -c '^### Requirement:' "$spec" || true)
    if [ "$reqs" -eq 0 ]; then
        echo "  [경고] $name: Requirement 블록이 없습니다"
        fail=1
    else
        echo "  [OK] $name — 요구사항 ${reqs}개"
    fi
done

# 아카이브되지 않은(진행 중) 변경 제안 확인 — 스펙과 코드가 어긋날 위험
pending=$(find "$CHANGES_DIR" -mindepth 1 -maxdepth 1 -type d ! -name archive 2>/dev/null || true)
if [ -n "$pending" ]; then
    echo "  [주의] 미완료 변경 제안이 있습니다:"
    echo "$pending" | sed 's/^/         - /'
    echo "         완료 후 openspec/changes/archive/ 로 옮기세요."
fi

if [ "$fail" -ne 0 ]; then
    echo "스펙 점검 실패" >&2
    exit 1
fi

echo
echo "== 앱 빌드 (make-only-app.sh 호출) =="
./make-only-app.sh

echo
echo "== 앱 실행 =="
killall MenuBarChat 2>/dev/null || true
sleep 1
killall -9 MenuBarChat 2>/dev/null || true
open build/MenuBarChat.app
sleep 2
if pid=$(pgrep MenuBarChat | head -1); [ -n "$pid" ]; then
    echo "완료: 메뉴 막대 아이콘을 확인하세요 (PID $pid)"
else
    echo "오류: 앱이 실행되지 않았습니다. 크래시 로그를 확인하세요:" >&2
    echo "  ls -t ~/Library/Logs/DiagnosticReports | grep -i menubarchat | head -1" >&2
    exit 1
fi
