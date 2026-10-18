# Proposal

## Why

답변 말풍선에서 드래그 선택·부분 복사가 불가능하다(지난 blank-bubble
수정으로 SwiftUI Text의 선택 기능을 제거 — 긴 attributed 문자열에서
선택 시작 시 렌더링이 탈락하는 프레임워크 버그 때문). AppKit TextKit의
선택 기계를 직접 감싸면 그 경로를 피하면서 네이티브 선택을 되살린다.

## What Changes

- 어시스턴트 답변 말풍선의 본문을 NSViewRepresentable로 감싼
  NSTextView(편집 불가·선택 가능)로 교체 — 드래그 선택·더블클릭 단어·
  Cmd+C 네이티브 동작, 마크다운 스타일은 기존 AttributedString을
  NSAttributedString으로 변환해 적용. 스트리밍 중 델타마다 재설정.
- 사용자·붙여넣기 말풍선과 복사 버튼(전문 복사)은 무변경.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 메시지 복사 — 답변 말풍선 텍스트 선택 제공

## Impact

- `Sources/MenuBarChat/ContentView.swift` — SelectableTextView
  (NSViewRepresentable) + 답변 본문 교체
- SelfTest — 대상 없음(뷰 계층, 수동 확인)
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
