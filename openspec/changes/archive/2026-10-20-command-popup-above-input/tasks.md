# Tasks

- [x] 1.1 명령 드롭다운 overlay 정렬 `.top` → `.bottom`(입력창 위 표시) —
  `swift build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: `/` 입력 — 드롭다운이 입력창 위에 떠서 입력 텍스트를
  가리지 않는지, 선택·Tab 완성 동작 유지

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-command-popup-above-input/`로 이동
