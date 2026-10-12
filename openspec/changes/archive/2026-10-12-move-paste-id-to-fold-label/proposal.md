# Proposal

## Why

붙여넣기 카드는 첨부 ID를 캡션 끝("붙여넣은 텍스트 · N줄 · ID<n>p")에
표시하고, 추론 말풍선은 More/Less 라벨 오른쪽("More, ID<n>p")에 표시해
ID 위치가 제각각이다. 접힘 대상의 ID는 접힘 스위치 옆에 두는 것이
형식을 통일하고 사용자 시선 이동도 줄인다.

## What Changes

- 붙여넣기 카드 캡션에서 ID를 제거해 "붙여넣은 텍스트 · N줄"로 줄이고,
  More/Less 라벨에 추론 말풍선과 같은 형식으로 ID를 오른쪽에 붙인다
  ("More, ID<n>p" / "Less, ID<n>p"). More/Less 버튼의 위치는 그대로다.
- chat-conversation 스펙의 "긴 붙여넣기 접기" 요구사항을 해당 형식으로
  수정한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 긴 붙여넣기 접기 — 카드 캡션에서 ID 제거, 접힘
  라벨에 ID 표시

## Impact

- `Sources/MenuBarChat/ContentView.swift` — MessageView 붙여넣기 카드
  캡션과 More/Less 라벨 (수 줄)
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
