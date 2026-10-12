# Proposal

## Why

거대한 텍스트를 붙여넣으면 `TextField(axis: .vertical)`이 전체 텍스트를
다시 레이아웃해 입력란이 크게 버벅인다. 이미지·파일 붙여넣기는 조용히
무시되거나(이미지) 경로 문자열이 쓰레기로 들어온다(파일). 이 앱의
모델(glm-5.3-flash/5.3/4.6)과 llm-provider 스펙은 텍스트 content만
다루므로, 처리 가능한 형식만 받고 나머지는 안내하는 것이 정직하다.

## What Changes

- 입력란에서 ⌘V를 가로채 붙여넣기를 분류한다:
  - 텍스트 10줄 이하 → 지금처럼 초안에 삽입
  - 텍스트 10줄 초과 → 즉시 "붙여넣기 칩"으로 승격(입력란은 비움,
    레이아웃 비용 0). 칩은 전송 시 본문이 되어 기존 긴 붙여넣기
    접기(`ID<n>p`) 흐름으로 들어간다. 칩에서 삭제/초안 되돌리기 가능.
  - 텍스트 없는 이미지·파일 → 짧은 안내("텍스트만 지원") 표시 후 거부.
    텍스트와 함께 있으면 텍스트만 취한다.
- 설정 섹션이 열려 있으면 가로채지 않는다(설정 필드는 일반 붙여넣기).

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 붙여넣기 형식 제한 요구사항 추가 (긴 텍스트 즉시
  승격, 비텍스트 거부·안내)

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — stagedPaste·pasteNotice 상태,
  전송 결합, 칩 조작
- `Sources/MenuBarChat/MenuBarChatApp.swift` — ⌘V 로컬 이벤트 모니터
- `Sources/MenuBarChat/ContentView.swift` — 칩·안내 캡션
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
