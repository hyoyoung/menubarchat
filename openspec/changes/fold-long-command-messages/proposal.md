# Proposal

## Why

`{previous}` 주입 후 명령 전개 메시지가 수백 줄이 되어 말풍선이 과도히
길어진다(실사용 관찰). 붙여넣기 분류(pasteID)는 건드리지 않는 표시 전용
접기로 해소한다.

## What Changes

- 10줄을 초과하는 명령 전개 메시지는 접힌 카드("명령 /이름 · N줄")로
  표시하고 More/Less로 펼친다 — 붙여넣기 접기와 같은 UI 패턴·isTextExpanded
  토글 재사용. pasteID·fetch·스텁·전송 규칙은 무변경(전문은 그 요청에
  그대로 실림). 10줄 이하는 전문 그대로.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 커스텀 슬래시 명령 — 긴 명령 메시지 표시 접기

## Impact

- `Sources/MenuBarChat/ContentView.swift` — MessageView 명령 분기
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
