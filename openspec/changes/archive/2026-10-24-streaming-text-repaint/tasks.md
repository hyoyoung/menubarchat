# Tasks

- [x] 1.1 SelectableTextView: sizeThatFits에 ensureLayout(for:) 추가,
  updateNSView에 needsDisplay·needsLayout = true 추가 — `swift build`
  통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: URL 붙여넣어 요약 스트리밍 — 응답 말풍선이 즉시
  갱신되고 백지가 재현되지 않는지(스크롤 없이), /news 다이제스트
  스트리밍도 무변경·마크다운·선택 유지

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-streaming-text-repaint/`로 이동
