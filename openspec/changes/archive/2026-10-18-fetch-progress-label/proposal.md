# Proposal

## Why

명령의 다중 fetch는 렌더링 포함 수 초~십수 초 걸리는데, 대기 문구가
"페이지 4개 가져오는 중…"으로 정지돼 있어 멈춘 듯 보인다. 완료 카운트로
진행을 보여준다. ETA는 사이트별 편차가 커 추정이 자주 틀려 채택하지
않는다(틀린 ETA는 없느니만 못함).

## What Changes

- 가져올 페이지가 2개 이상이면 문구를 "페이지 n/N 가져오는 중…"으로
  표시하고 n을 완료(성공·실패 포함)될 때마다 갱신한다. 1개면 기존
  "페이지 가져오는 중…"을 유지한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 응답 대기 표시 — 진행 카운트 문구

## Impact

- `Sources/MenuBarChat/ContentView.swift` — 대기 문구 (라벨 한 곳)
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
