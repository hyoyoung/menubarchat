# Tasks

- [x] 1.1 stream()의 thinkingBudget을 settings.thinkingBudget으로 복원,
  effectiveThinkingBudget·isURLOnlyMessage 래퍼·SelfTest 2건 제거 —
  selftest 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 사고 수준 high에서 /news·URL 요약이 모두 긴 추론으로
  복귀

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-revert-thinking-default/`로 이동
