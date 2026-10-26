# Proposal

## Why

접힘 조건이 대상별로 제각각이다 — 붙여넣기 10줄, 추론 5줄, 명령 5줄/100자.
세 카드 유형(붙여넣기·명령·추론)을 "줄바꿈 5개 초과 또는 100자 초과"로
통일한다(사용자 확정).

## What Changes

- 추론: 접힘 조건에 100자 초과 추가.
- 붙여넣기·일반 사용자 텍스트: pasteID 첨부(기존 10줄 분류) 또는
  5/100 초과인 일반 텍스트도 접힌 카드로 표시(첨부 없는 경우 ID 없는
  "붙여넣은 텍스트 · N줄" 라벨).
- 명령 카드: 이미 5/100 — 무변경. 답변 본문: 항상 펼침 — 무변경.
- 첨부 분류(pasteID 부여·URL fetch 규칙)는 10줄 기준 그대로 — 표시만
  통일.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 긴 붙여넣기 접기·추론 말풍선 접기 — 접힘 조건

## Impact

- `Sources/MenuBarChat/ContentView.swift` — needsFold·붙여넣기 분기
- `openspec/specs/chat-conversation/spec.md` — 요구사항 2건 (아카이브 시
  반영)
