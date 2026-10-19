# Tasks

- [x] 1.1 명령 접힌 카드에 앞 5줄 미리보기(lineLimit 5, 보조 글씨)
  추가 — `swift build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 이력 있는 /news — 카드에 프롬프트 지시부 5줄이
  보이고 More로 전문, 10줄 이하는 무변경

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-command-fold-preview/`로 이동
