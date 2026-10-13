# Proposal

## Why

전송 후 첫 답변 델타가 도착할 때까지(네트워크 RTT + 모델 prefill +
thinking budget) 답변 자리가 비어 있어 앱이 멈춘 것처럼 보인다.

## What Changes

- 스트리밍이 진행 중이고 마지막 메시지가 어시스턴트가 아닐 때, 답변이
  올 자리에 어시스턴트 스타일 말풍선 형태의 대기 표시(작은 스피너)를
  띄운다.
- 첫 델타가 도착해 답변 말풍선이 만들어지면 자리는 자동으로 사라지고
  실제 내용으로 이어진다. 오류로 끝나면 기존 오류 말풍선 경로가 그대로
  이어진다.
- 페이지 fetch 중에는 이미 "페이지 가져오는 중…" 표시가 있으므로 대기
  자리를 숨겨 이중 스피너를 막는다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 응답 대기 표시 요구사항 추가

## Impact

- `Sources/MenuBarChat/ContentView.swift` — 조건부 대기 자리 (수 줄)
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
- 상태·모델 변경 없음 (UI 조건부 — @State 불가 제약 회피)
