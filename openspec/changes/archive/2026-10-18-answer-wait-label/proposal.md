# Proposal

## Why

페이지 가져오기가 끝난 뒤 답변 첫 델타를 기다리는 스피너가 무문구로
오래 머물러 멈춘 듯 보인다(실사용 관찰 — 추론 도착 후에도 빈 스피너).

## What Changes

- 가져오기 문구가 꺼진 뒤(가져올 페이지가 없거나 가져오기 완료)에도
  첫 답변 델타 전이라면 스피너 옆에 "답변 생성 중…" 문구를 표시한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 응답 대기 표시 — 답변 생성 대기 문구

## Impact

- `Sources/MenuBarChat/ContentView.swift` — 대기 문구 (한 곳)
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
