# Proposal

## Why

이전 다이제스트 반복 제거가 새 주제를 아직 다룬 것으로 오탐하거나 깨끗한
재시작을 원할 때, 이력을 비우는 즉시 수단이 없다(파일을 수동으로 지워야
함).

## What Changes

- 내장 로컬 명령 `/clear-previous-news` 추가: 이력 링 전체를 비우고
  확인 말풍선("이전 다이제스트 이력을 지웠습니다.")을 표시한다 — 요청·
  fetch·스트리밍 없음, 스트리밍 중 무시. 이후 /news는 `{previous}`가
  "none"으로 새 출발한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 커스텀 슬래시 명령 — 로컬 명령 조항 확장

## Impact

- `Sources/MenuBarChat/NewsHistory.swift` — clear()
- `Sources/MenuBarChat/ChatModel.swift` — send() 가로채 한 분기
- `Sources/MenuBarChat/SettingsStore.swift` — builtinCommands 등록
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
