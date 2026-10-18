# Proposal

## Why

명령으로 전개된 프롬프트 전문이 사용자 히스토리에 상주해 이후 모든
요청에 재전송된다. 그 결과 명령 실행 뒤 붙여넣은 단일 URL조차 "다이제스트
작업의 일부"로 해석되어 전체 소스 요약이 시도되고(실사용 관찰), 토큰도
매번 낭비된다.

## What Changes

- 첨부(페이지·붙여넣기·이미지)와 같은 대칭 규칙을 명령 프롬프트에 적용:
  전개된 프롬프트는 그 메시지가 마지막인 요청에만 전문으로 실리고, 이후
  요청부터는 해당 메시지 자리를 `[Command: /이름]` 스텁으로 대체한다.
- 스텁에는 지시문·URL 목록이 남지 않아 이후 단일 URL 메시지가 새 작업으로
  해석된다. 페이지 스텁(`[Page ID<n> …]`)은 기존대로 함께 표시된다.
- 표시(화면)는 무변경 — 전문 그대로.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 커스텀 슬래시 명령 — 과거 명령 메시지의 스텁화

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — Message에 `commandName` 저장
  (전개 시점)
- `Sources/MenuBarChat/PromptComposer.swift` — 비-마지막 명령 메시지 스텁
- SelfTest — 스텁화·마지막 전문 유지 회귀
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
