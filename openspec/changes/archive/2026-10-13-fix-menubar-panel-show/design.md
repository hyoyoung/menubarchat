# Design

## Context

재현: 브라우저 등 다른 앱 사용 중(앱 비활성) 상태 항목 첫 클릭 무반응,
둘째 클릭에 표시. 현재 `showPanelBelowIcon`은
`makeKeyAndOrderFront` → `NSApp.activate` 순서이고 `togglePanel`은
`panel.isVisible` 플래그만 본다. 위치 클램프는
`NSScreen.screens.first`(메인 화면) 고정.

## Goals / Non-Goals

**Goals:**

- 비활성 상태에서도 한 번 클릭에 패널 표시
- "플래그만 visible" 상태에서 첫 클릭이 숨김으로 소진되지 않게

**Non-Goals:**

- 패널 자동 숨김(포커스 잃으면 닫기), Dock 아이콘 전환

## Decisions

### D1: 활성화 먼저, 표시 나중

`NSApp.activate(ignoringOtherApps: true)` → `setFrameOrigin` →
`makeKeyAndOrderFront` 순서로 바꾼다. 비활성 앱의 전면 배치가
무시되는 경로를 끊는 표준 처방.

### D2: 숨김 판정은 실가시성 — `occlusionState` 병용

```swift
private var panelReallyVisible: Bool {
    panel.isVisible && panel.occlusionState.contains(.visible)
}
```

진짜 보일 때만 orderOut하고, 그 외(플래그만 true)는 show 경로로
재배치·재표시한다. 첫 클릭이 언제나 "보이는 결과"를 만든다.

### D3: 클램프는 아이콘 화면 기준

`iconFrame`의 midX를 포함하는 `NSScreen`(없으면 main)의 visibleFrame로
클램프한다. 보조 디스플레이에서 패널이 메인 화면으로 건너가는 오배치
해소.

## Risks / Trade-offs

- [첫 클릭 활성화 삼킴(macOS 액세서리 앱 유령 버그)이 잔존] → D1이
  대부분 경로를 교정한다. 재현이 남으면 앱 활성 직후 이벤트 재전달 같은
  후속 완화를 별도 변경으로.
- [occlusionState 미세 지연] → 클릭 시점 판정은 사용자가 눈으로 본 상태와
  일치하는 경우가 대부분. 불일치 시 동작은 "재표시"라 안전 방향.

## Migration Plan

1. showPanelBelowIcon 순서 교정 + 화면 선택 수정
2. togglePanel 실가시성 판정
3. `swift build` → `./openspec-all-build.sh` → 수동 재현 확인
   (브라우저 포커스 상태에서 한 번 클릭)
