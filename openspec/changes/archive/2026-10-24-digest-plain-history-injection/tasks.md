# Tasks

- [x] 1.1 NewsHistory.previousContext에 마크업 살균 추가(강조 기호 제거·
  `[제목](url)` → 제목) + SelfTest(살균·링크 풀기) — selftest 통과으로
  확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 이력 있는 상태에서 /news — 기울임 제목 소멸·양쪽
  섹션 모두 굵게, 반복 제거는 여전히 동작(중복 억제 유지)

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-digest-plain-history-injection/`로 이동
