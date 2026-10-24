# Proposal

## Why

스트리밍 중 전송하고 싶은 메시지가 여럿일 때 대기열이 1개라 부족하다.
용량을 3으로 확장한다(사용자 지정).

## What Changes

- 대기열 최대 3개 — FIFO(먼저 넣은 것부터 스트림 종료 후 순차 자동
  전송), 4번째 Enter부터 무시·초안 유지. 항목별 즉시 전송·삭제·초안
  되돌리기·전체 해제는 그대로 3개 리스트로 동작.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 메시지 전송 — 대기열 용량

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — queuedMessage 배열화(명령
  플래그·fetch 대상 포함)·종료 시 첫 항목 전송
- `Sources/MenuBarChat/ContentView.swift` — 대기 목록 리스트 렌더
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
