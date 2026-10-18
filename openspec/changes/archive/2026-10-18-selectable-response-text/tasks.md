# Tasks

- [x] 1.1 SelectableTextView(NSViewRepresentable, 편집 불가·선택 가능
  NSTextView, AttributedString→NSAttributedString 변환, 폭 기반 높이
  측정) 구현 + 어시스턴트 본문 Text 교체 — `swift build` 통과로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 긴 다이제스트 말풍선 — 드래그 선택·더블클릭 단어·
  Cmd+C 부분 복사, 클릭만으로 공백 재현 없음, 스트리밍 중 갱신·
  마크다운 스타일·복사 버튼·스크롤 핀 회귀 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-selectable-response-text/`로 이동
