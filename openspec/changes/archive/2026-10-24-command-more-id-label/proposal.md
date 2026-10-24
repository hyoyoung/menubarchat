# Proposal

## Why

접힌 명령 카드의 More/Less 라벨만 ID가 없다 — 추론("More, ID1")·붙여넣기
("More, ID3p") 관례와 어긋나고, 소스 묶음 ID를 말풍선에서 바로 알 수
없다.

## What Changes

- 접힌 명령 카드의 More/Less 라벨에 소스 묶음 ID 접미를 붙인다 —
  `pageBundleID > 0`이면 "More, ID<n>" / "Less, ID<n>", 없으면 그대로.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 커스텀 슬래시 명령 — 접힌 카드 라벨 ID 표시

## Impact

- `Sources/MenuBarChat/ContentView.swift` — 라벨 한 곳
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
