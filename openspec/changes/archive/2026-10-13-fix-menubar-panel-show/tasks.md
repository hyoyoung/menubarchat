# Tasks

## 1. 교정

- [x] 1.1 `showPanelBelowIcon`에서 `NSApp.activate`를
  `makeKeyAndOrderFront` 앞으로 이동하고, 클램프 계산을 아이콘이 속한
  화면 기준으로 수정 — `swift build` 통과로 확인
- [x] 1.2 `togglePanel`의 숨김 조건을 `isVisible &&
  occlusionState.contains(.visible)`로 교체 — `swift build` 통과로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 재현 확인: 브라우저 등 다른 앱 포커스 상태에서 상태 항목
  한 번 클릭 → 패널 즉시 표시(두 번 클릭 불필요), 보조 디스플레이에서도
  아이콘 아래에 표시, 패널 보임 상태 재클릭 → 정상 숨김

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-fix-menubar-panel-show/`로 이동
