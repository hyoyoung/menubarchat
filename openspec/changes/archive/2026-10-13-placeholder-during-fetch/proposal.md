# Proposal

## Why

대기 말풍선이 페이지 fetch가 끝난 뒤에야 나타나, URL 메시지를 보내면
"페이지 가져오는 중…" 표시와 대기 말풍선이 단절된 두 단계로 보인다.
전송 직후부터 하나의 연속된 대기 말풍선이 떠 있는 편이 자연스럽다.

## What Changes

- 대기 말풍선을 전송 직후(페이지 fetch 중 포함)부터 표시한다. fetch
  중에는 스피너 옆에 "페이지 가져오는 중…" 문구를 함께 표시하고, fetch가
  끝나면 문구만 빠진다.
- 추론(reasoning)만 도착한 동안에도 답변 자리(추론 말풍선 아래)에 대기
  표시를 유지한다 — 추론 스트림 종료 후 답변 첫 토큰까지의 공백도
  메워진다.
- 기존의 별도 가져오기 표시(사용자 메시지 아래 작은 표시)는 제거하고
  대기 말풍선으로 통합한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 응답 대기 표시 — 페이지 가져오기 중에도 표시하며
  문구를 함께 표시

## Impact

- `Sources/MenuBarChat/ContentView.swift` — 대기 말풍선 조건에서
  `!isFetchingPage` 제거 + fetch 문구 추가, 기존 가져오기 표시 블록 제거
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
