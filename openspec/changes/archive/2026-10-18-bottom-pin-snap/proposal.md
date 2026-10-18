# Proposal

## Why

팔로우 재개 판정은 "바닥 40pt 이내" 관용 간격으로, 이동 명령(scrollTo)은
정확한 바닥을 목적지로 삼는다. 사용자가 관용 간격 안에서 멈춘 뒤 델타가
도착하면 스냅이 사용자 위치보다 살짝 위로 점프해 보인다(실사용 관찰).

## What Changes

- followsBottom이 false→true로 전환되는 순간(뷰포트가 바닥에 도달해
  재개될 때) 즉시 한 번 스크롤을 고정점에 스냅해 관용 간격을 흡수한다.
  이후 델타 핀은 같은 앵커로 가므로 상대적 점프가 사라진다.
- 바닥 목적지 계산(대기 표시 행 vs 마지막 메시지)을 한 헬퍼로 통합
  (현재 3곳 중복).

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 스트리밍 표시 — 재개 시 즉시 고정 명시

## Impact

- `Sources/MenuBarChat/ContentView.swift` — 마커 재개 분기 + 스크롤
  헬퍼 통합
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
