# Proposal

## Why

패널을 숨겼다 다시 표시하면 SwiftUI ScrollView가 잘못 복원된 오프셋으로
점프하고 LazyVStack 행이 아직 재료화되지 않아 백지로 보인다 — 표시
시점에 바닥 재핀 이벤트가 없어 아무도 교정하지 않는다(실사용 관찰).

## What Changes

- 패널 표시 시 `followsBottom`이면 재핀 요청 플래그를 설정하고
  ContentView가 이를 관찰해 바닥으로 스크롤한다. 팔로우 중이 아닌
  상태(사용자가 위로 올려 둠)는 간섭하지 않는다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

(없음 — 스크롤 신뢰성 수정, skip_specs)

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — 재핀 요청 플래그
- `Sources/MenuBarChat/MenuBarChatApp.swift` — 표시 시 플래그 설정
- `Sources/MenuBarChat/ContentView.swift` — 플래그 관찰 스크롤
