# Tasks

- [ ] 1.1 시드 프롬프트 교체: "top 15 computer, science, mathematics, and
  information technology news stories", 심화 줄 "For major or trending
  stories", 비주요 섹션 "events outside these fields" + SelfTest 기대값
  갱신 — selftest 통과로 확인

## 2. 검증

- [ ] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [ ] 2.2 수동 확인: 앱 재시작 후 `/news` 전개 프롬프트에 네 분야
  표기, 다이제스트가 과학·수학 뉴스도 포함

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-news-prompt-stem-scope/`로 이동
