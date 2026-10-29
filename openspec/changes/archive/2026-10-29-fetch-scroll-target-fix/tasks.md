# Tasks

- [x] 1.1 scrollToBottom 목표 선택 교체(사용자 메시지=실존 행 우선,
  빈 어시스턴트일 때만 placeholder) — `swift build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: URL 전송 — fetch 중 위로 지나친 스크롤 없이 바닥
  유지, 스트리밍 중 핀·숨김/표시 재핀 회귀 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-fetch-scroll-target-fix/`로 이동
