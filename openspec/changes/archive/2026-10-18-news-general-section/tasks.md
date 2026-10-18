# Tasks

- [x] 1.1 내장 news 프롬프트의 비STEM 섹션 문장을 "the top 15 general
  news stories"로 교체 + SelfTest 기대값 갱신 — selftest 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 재시작 후 `/news` — 전개 프롬프트에 general news
  문구, 다이제스트 두 번째 섹션이 일반 뉴스 15개로 정리되는지

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-news-general-section/`로 이동
