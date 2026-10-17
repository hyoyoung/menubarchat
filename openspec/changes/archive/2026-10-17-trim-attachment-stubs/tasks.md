# Tasks

- [x] 1.1 PromptComposer 스텁 3곳에서 `— mention "…" to re-include`
  접미사 제거(페이지·붙여넣기·이미지) + SelfTest 기대값 3건 갱신 —
  selftest 통과로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: URL 요약 몇 번 수행 후 후속 질문 — 답변에 ID
  인터페이스 안내문이 더 이상 등장하지 않음, `ID<n>` 직접 언급 시
  재포함 정상 동작

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-trim-attachment-stubs/`로 이동
