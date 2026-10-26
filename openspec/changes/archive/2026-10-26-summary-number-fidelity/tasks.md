# Tasks

- [x] 1.1 PromptComposer.untrustedPreamble에 숫자 충실도 문장 추가 +
  SelfTest 기대값 갱신 — selftest 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 숫자·범위가 많은 기사 URL 요약 — 자릿수 병합 없이
  원문 수치 유지

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-summary-number-fidelity/`로 이동
