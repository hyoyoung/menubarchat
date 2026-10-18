# Tasks

- [x] 1.1 메시지 본문 Text 4곳(어시스턴트·사용자·붙여넣기 확장·추론)에서
  `.textSelection(.enabled)` 제거 — `swift build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 긴 다이제스트 말풍선 클릭(더블클릭·드래그 시도
  포함) → 공백으로 떨어지지 않음, 복사 버튼 정상 동작

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-blank-bubble-on-click/`로 이동
