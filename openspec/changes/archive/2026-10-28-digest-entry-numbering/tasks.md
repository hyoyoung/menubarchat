# Tasks

- [x] 1.1 내장 news 프롬프트 형식 문장에 번호(N.) 삽입 — STEM `N.
  **[Title](URL)**`·`N. **Title**`, 일반 `N. [Title](URL)`·`N. Title` —
  + SelfTest 기대값 갱신 — selftest 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: /news — 양쪽 섹션 모든 항목에 일관된 번호
  (1. 2. 3. …), 서식·링크·밀도 회귀 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-digest-entry-numbering/`로 이동
