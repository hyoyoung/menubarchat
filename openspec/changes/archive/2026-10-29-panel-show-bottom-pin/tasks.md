# Tasks

- [x] 1.1 ChatModel 재핀 요청 플래그 + showPanelBelowIcon에서
  followsBottom일 때 설정 + ContentView onChange 관찰 스크롤 — `swift
  build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 팔로우 상태에서 숨김→표시 반복 — 백지 없이 바닥
  고정, 위로 올려둔 상태에서 표시하면 위치 간섭 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-panel-show-bottom-pin/`로 이동
