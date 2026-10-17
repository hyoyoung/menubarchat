# Tasks

## 1. 규칙

- [x] 1.1 `PromptComposer.transcript()`에 텍스트 없음 판정 추가: 마지막
  사용자 메시지가 URL 단독(`isURLOnly`)이거나 이미지 첨부 + 빈 텍스트면
  어시스턴트 답변 전원 제외 + SelfTest 2건(URL 단독 → 답변 0개,
  텍스트 동반 → 직전 1개 유지) — selftest 통과로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: URL만 붙여 전송 → 요약 정상(직전 답변 없이),
  텍스트 동반 후속 질문 → 직전 답변 참조 정상, 이미지만 전송 → 정상

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-k0-textless-messages/`로 이동
