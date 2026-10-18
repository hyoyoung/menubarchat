# Tasks

- [ ] 1.1 내장 news 프롬프트: 비STEM 섹션 "the top 15 important or
  unusual events outside STEM" 상한 지정 + "— skip typical news without
  mentioning exclusions." + SelfTest 기대값 갱신 — selftest 통과으로 확인
- [ ] 1.2 markdown() 전처리에 3+ 연속 줄바꿈 → `\n\n` 접기 추가 +
  SelfTest(접기·2개 유지) — selftest 통과으로 확인

## 2. 검증

- [ ] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [ ] 2.2 수동 확인: `/news` — 제외 안내문(※ …)이 사라지는지, 다중
  빈 줄이 접히는지, 기존 마크다운 렌더 회귀 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-digest-output-polish/`로 이동
