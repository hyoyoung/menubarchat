# Proposal

## Why

다른 앱(예: 브라우저) 작업 중 앱이 비활성 상태일 때 상태 항목 첫 클릭이
무반응이고 두 번째 클릭에야 패널이 뜬다(재현 확인). 원인은 둘: ①
`makeKeyAndOrderFront`가 `NSApp.activate`보다 앞서 비활성 상태에서 전면
배치가 무시되는 경우, ② `panel.isVisible` 플래그는 true인데 실제로는 안
보이는(가려짐·다른 화면) 상태에서 첫 클릭이 "숨기기"로 소진되는 경우.

## What Changes

- 활성화 순서 교정: `NSApp.activate(ignoringOtherApps: true)`를 패널
  표시보다 먼저 실행한다.
- 토글 판정을 실가시성 기준으로: `isVisible`과 `occlusionState`가 모두
  보임일 때만 숨기고, 플래그만 true면 숨기지 않고 아이콘 아래 재배치해
  재표시한다.
- 패널 위치 클램프를 아이콘이 속한 화면 기준으로 계산한다(현재 메인
  화면 고정이라 보조 디스플레이에서 패널이 엉뚱한 곳에 갈 수 있음).

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `menubar-presence`: 채팅 패널 토글 — 실가시성 판정과 재표시, 활성화
  순서, 아이콘 화면 기준 클램프

## Impact

- `Sources/MenuBarChat/MenuBarChatApp.swift` — showPanelBelowIcon,
  togglePanel 수정 (수 줄)
- `openspec/specs/menubar-presence/spec.md` — 요구사항 1건 (아카이브 시
  반영)
