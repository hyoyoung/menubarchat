# Proposal

## Why

방금 본 다이제스트를 다시 보고 싶을 때 `/news`를 재실행하면 fetch·
토큰을 다시 쓴다. 이미 이력 링에 저장된 최신 다이제스트를 로컬에서
즉시 다시 표시하는 명령이면 충분하다.

## What Changes

- 내장 명령 `/previous-news` 추가: 전송 시 프롬프트 전개 대신 로컬
  동작으로 이력 링의 최신 항목(24시간 창)을 어시스턴트 말풍선으로
  삽입한다 — 요청·fetch·스트리밍 없음, 복사 버튼·마크다운 렌더는 일반
  답변과 동일. 링이 비었으면 "저장된 다이제스트가 없습니다" 안내
  말풍선. 표시된 다이제스트는 이력에 다시 저장하지 않는다.
- 드롭다운·Tab 완성은 일반 명령과 같이 동작(builtinCommands 등록,
  프롬프트 필드 미사용).

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 커스텀 슬래시 명령 — 로컬 명령 분기 명시

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — send() 가로채·말풍선 삽입
- `Sources/MenuBarChat/SettingsStore.swift` — builtinCommands 등록
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
