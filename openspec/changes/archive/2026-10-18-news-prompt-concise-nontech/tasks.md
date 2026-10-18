# Tasks

- [x] 1.1 시드 프롬프트 교체: 심화 줄을 IT 뉴스로 한정("For major or
  trending IT stories"), 비IT 섹션 한 줄 간결 지시("each as a single
  concise line") 추가 + SelfTest 기대값 갱신 — selftest 통과로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 앱 재시작 후 `/news` — IT 주요 뉴스에만 심화 줄,
  비IT 섹션은 항목당 한 줄

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-news-prompt-concise-nontech/`로 이동
