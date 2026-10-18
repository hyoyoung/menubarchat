# Tasks

- [ ] 1.1 시드 프롬프트 교체: tech → "computer/IT (information
  technology) news", 주요·화제 뉴스 2~3줄 심화 지시 추가 + SelfTest
  기대값 갱신 — selftest 통과로 확인

## 2. 검증

- [ ] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [ ] 2.2 수동 확인: 앱 재시작 후 `/news` 전개 프롬프트에 IT 한정·심화
  줄 지시 포함, 다이제스트가 컴퓨터·IT 뉴스 중심 + 주요 뉴스 상세

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-news-prompt-refine/`로 이동
