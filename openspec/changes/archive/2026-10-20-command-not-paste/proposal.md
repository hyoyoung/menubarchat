# Proposal

## Why

명령 전개 프롬프트에 `{previous}`(직전 다이제스트)가 주입되면 10줄을
초과해 `isLongPaste`로 분류된다 — 붙여넣기 카드로 접히고 fetch 가드
(pasteID == 0)가 붙어 URL fetch까지 건너뛴다(두 번째 /news 실행부터
발생, 실사용 관찰).

## What Changes

- 긴 붙여넣기 분류에서 명령 전개 메시지(viaCommand)를 제외한다 —
  앱이 생성한 명령 프롬프트는 길이와 무관하게 명령 메시지로 동작한다
  (전문 표시 → `[Command: /이름]` 스텁, URL fetch 정상, 접기 없음).

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 웹 페이지 읽기 — 10줄 조건의 적용 대상 명시,
  긴 붙여넣기 접기 — 명령 전개 메시지 제외

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — 분기 한 줄
- SelfTest — isLongPaste 경유 분류 회귀(순수 함수 범위 확인)
- `openspec/specs/chat-conversation/spec.md` — 요구사항 2건 (아카이브 시
  반영)
