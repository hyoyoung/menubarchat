# Tasks

- [x] 1.1 내장 news 프롬프트의 이전 다이제스트 지시를 "keep
  already-covered STEM stories unless minor, and skip already-covered
  general news unless it is a major development"로 교체 + SelfTest
  기대값 갱신 — selftest 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: `/news` 두 번 연속 — 두 번째에서 사소한 중복은
  빠지고 진행 중인 중요 이슈는 유지되는지

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-news-dedup-major-keep/`로 이동
