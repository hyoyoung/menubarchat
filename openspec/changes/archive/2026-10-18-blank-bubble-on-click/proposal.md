# Proposal

## Why

긴 단일 AttributedString(다이제스트 등)에서 `.textSelection(.enabled)`인
Text를 클릭해 선택을 시작하면 macOS SwiftUI가 레이아웃에 실패해 말풍선이
공백으로 렌더링된다(실사용 관찰 — 데이터는 멀쩡, 렌더링만 탈락).

## What Changes

- 메시지 본문 Text(어시스턴트 답변·사용자·붙여넣기 확장·추론)에서
  `.textSelection(.enabled)`를 제거한다. 텍스트 복사는 기존 말풍선별
  복사 버튼이 담당한다(스펙 "메시지 복사").

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 메시지 복사 — 드래그 선택 미제공 명시

## Impact

- `Sources/MenuBarChat/ContentView.swift` — selection 제거 4곳
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
