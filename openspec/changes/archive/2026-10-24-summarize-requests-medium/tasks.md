# Tasks

- [x] 1.1 stream()에서 요약형 요청 판정(마지막 사용자 메시지 URL-only·
  pasteID>0·뉴스 명령) 시 페이로드 thinking_budget "medium" 오버라이드 +
  SelfTest(판정 순수 함수) — selftest 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 설정 사고 수준 high에서 /news와 URL 요약 — 추론이
  짧아지고 첫 답변까지 눈에 띄게 빨라지는지, 혼합 메시지·일반 대화는
  긴 추론 유지

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-summarize-requests-medium/`로 이동
