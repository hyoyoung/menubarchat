# Proposal

## Why

fetch 대상을 메시지 텍스트에서 추출하는데, 명령 전개 메시지는 `{previous}`
주입으로 이전 다이제스트의 기사 URL까지 포함한다 — 상한 10개 중 6개가
이력 것으로 채워져 느리고 소스 카드에 엉뚱한 사이트가 섞인다(실사용
관찰).

## What Changes

- 명령 메시지의 fetch 대상을 `{previous}` 주입 "전" 프롬프트에서 미리
  계산해 메시지에 저장하고, fetch는 그 목록을 사용한다. 일반 메시지는
  기존대로 텍스트에서 첫 URL을 추출한다. 명령은 프롬프트 자체의 URL만
  가져온다(이력 주입분 제외).

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 웹 페이지 읽기 — 명령의 fetch 대상 명시

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — send 흐름·Message.pageTargets·
  fetch 분기
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
