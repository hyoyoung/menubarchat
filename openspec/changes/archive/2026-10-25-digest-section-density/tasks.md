# Tasks

- [x] 1.1 내장 news 프롬프트: STEM 심화 문장 교체(모든 항목 제목 아래
  2-3줄 — 그 줄이 요약·심화 전부, 화제·중요는 최대 5줄) + 일반에
  "한 줄 고정·부가 줄 금지" 문장 추가 + SelfTest 기대값 갱신 — selftest
  통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: /news — STEM 모든 항목에 2-3줄 심화(상위 화제건은
  최대 5줄), 일반은 모든 항목이 정확히 한 줄

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-digest-section-density/`로 이동
