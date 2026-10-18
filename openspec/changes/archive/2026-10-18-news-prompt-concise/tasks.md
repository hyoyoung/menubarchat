# Tasks

- [x] 1.1 내장 news 프롬프트를 간결판(STEM 치환·군더더기 제거·"skip
  typical news" 일반화)으로 교체 + SelfTest 기대값 갱신 — selftest
  통과로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 재시작 후 `/news` 전개 프롬프트가 간결판,
  다이제스트 품질 유지(STEM 범위·심화·비STEM 한 줄·사고 제외·한국어)

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-news-prompt-concise/`로 이동
