# Tasks

- [x] 1.1 접힌 명령 카드의 More/Less 라벨에 `, ID<n>` 접미 추가
  (pageBundleID > 0 때만) — `swift build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: /news — 접힌 카드 라벨이 "More, ID1"로 표시, 펼치면
  "Less, ID1", 묶음 없는 명령은 그대로 "More"

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-command-more-id-label/`로 이동
