# Tasks

- [x] 1.1 sendNow의 긴 붙여넣기 분류에 `viaCommand == false` 가드 추가 +
  SelfTest(커버 가능한 순수 범위 — isLongPaste 분류가 명령 경로를
  건너뛰는 것은 수동 확인) — `swift build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: `/news` 실행 → 다시 `/news` — 두 번째가 붙여넣기
  카드가 아니라 명령 메시지로 표시되고 4개 사이트 fetch·소스 카드가
  정상이며 이전 다이제스트 주입도 유지되는지, 일반 긴 붙여넣기 접기는
  회귀 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-command-not-paste/`로 이동
