# Proposal

## Why

응답이 스트리밍되는 동안 매 델타마다 하단으로 자동 스크롤되어, 사용자가
올려둔 스크롤 위치가 무시되고 화면이 계속 끌려간다. 읽던 줄을 유지하며
스트리밍을 지켜볼 수 없다.

## What Changes

- 자동 스크롤을 "팔로우" 상태로 만들고, 사용자가 위로 스크롤하면 팔로우를
  끊어 현재 위치를 유지한다(스트리밍 중에도 점프 없음).
- 팔로우가 끊긴 동안에만 기록 목록 하단에 떠 있는 점프 버튼(아래 화살표)
  을 표시하고, 누르면 즉시 맨 아래로 돌아가 팔로우를 재개한다.
- 메시지를 직접 전송하면 팔로우를 자동 재개한다(자기 메시지로 점프).
- 판정: 스크롤 휠/제스처 "위" 방향 입력만 팔로우를 끊고, 뷰포트가 맨
  아래에 도달하면 재개한다. 자동 스크롤 자체는 사용자 입력이 아니므로
  팔로우를 끊지 않는다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 스트리밍 표시 — 자동 스크롤을 팔로우 상태로 조건화,
  점프 버록 표시

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — `@Published var followsBottom`
  상태, 전송 시 재개
- `Sources/MenuBarChat/MenuBarChatApp.swift` — scrollWheel 로컬 모니터
  (위 방향 → 팔로우 해제)
- `Sources/MenuBarChat/ContentView.swift` — 조건부 자동 스크롤, 하단
  도달 감지(GeometryReader), 떠 있는 점프 버튼
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
