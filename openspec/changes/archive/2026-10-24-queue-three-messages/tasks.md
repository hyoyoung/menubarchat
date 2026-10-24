# Tasks

- [x] 1.1 ChatModel: queuedMessage 단일 값을 최대 3개 배열(텍스트·
  viaCommand·commandName·fetchTargets)로 전환, 종료 시 첫 항목 전송·
  나머지 유지, 항목 조작·전체 해제 갱신 — `swift build` 통과으로 확인
- [x] 1.2 ContentView: 대기 목록을 배열 리스트로 렌더(항목별 버튼
  유지) — `swift build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 스트리밍 중 3개까지 대기·목록 표시, 4번째 무시,
  종료 후 순차 자동 전송, 항목별 즉시 전송·삭제·되돌리기·전체 해제

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-queue-three-messages/`로 이동
