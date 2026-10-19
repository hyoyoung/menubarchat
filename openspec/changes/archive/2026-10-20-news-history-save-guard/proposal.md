# Proposal

## Why

저장 훅이 "뉴스 명령의 정상 종료 응답"이면 무조건 링에 append한다 —
fetch가 실패·스킵된 실행의 거절 답변(직전 질문에 대한 답변이 섞인
키메라 포함)도 저장돼, 다음 /news가 그 쓰레기를 `{previous}`로 주입했다
(실사용 관찰).

## What Changes

- 저장 조건에 "성공적으로 가져온 페이지 1개 이상"을 추가한다 — 이력은
  소스 기반 다이제스트만 기억한다. fetch 없이 응답한 거절문·안내문은
  저장되지 않는다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 뉴스 다이제스트 이력 — 저장 조건 보강

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — saveNewsHistoryIfNeeded 조건
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
