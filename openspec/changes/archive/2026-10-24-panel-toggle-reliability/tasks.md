# Tasks

- [x] 1.1 togglePanel 숨김 조건을 `panel.isVisible && panel.isKeyWindow`로
  교체 — `swift build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 패널 열린 채로 다른 앱 클릭(가림) → 메뉴 막대
  아이콘 클릭 — 첫 클릭에 패널이 바로 보임(죽은 클릭 없음), 패널
  조작 중 클릭은 여전히 숨김, 다른 Space에서도 첫 클릭 재현

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-panel-toggle-reliability/`로 이동
