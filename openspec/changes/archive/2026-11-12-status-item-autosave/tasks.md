# Tasks

- [x] 1.1 statusItem.autosaveName = "MenuBarChatStatusItem" 추가 — `swift
  build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 아이콘 위치를 옮긴 뒤 재시작 — 같은 자리 유지
  (Hidden Bar 구분자 왼쪽에 두면 계속 보임)

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-status-item-autosave/`로 이동
