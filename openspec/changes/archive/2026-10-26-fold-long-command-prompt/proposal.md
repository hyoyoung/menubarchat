# Proposal

## Why

접힘 조건이 "줄바꿈 10개 초과"라 줄바꿈 없는 한 문단인 /news 프롬프트(약
1,200자)가 이력 없는 첫 실행에서 전문으로 펼쳐 보인다 — 논리줄과 시각
길이가 어긋난다.

## What Changes

- 명령 전개 메시지의 접힘 조건을 "줄바꿈 5개 초과 또는 100자 초과"로
  확장한다 — 시각적으로 긴 프롬프트는 이력 유무와 무관하게 항상 접힌다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 커스텀 슬래시 명령 — 접힘 조건

## Impact

- `Sources/MenuBarChat/ContentView.swift` — 접힘 분기 조건
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
