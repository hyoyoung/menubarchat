# Tasks

## 1. 모델

- [x] 1.1 ChatModel에 `@Published var queuedMessage: String?` 추가,
  `send()`를 검증 래퍼(빈 입력·빈 키·스트리밍 분기: 대기)와
  `sendNow(_:)`(기존 전송 동작)로 분리, 스트림 종료 후 큐 드레인
  (해제 후 `sendNow` 호출) — `swift build` 통과로 확인

## 2. 표시

- [x] 2.1 ContentView에 대기 패널 추가: 헤더("대기 메시지 1개" + "모두
  지우기" ⌥⌘⌫), 항목 행(상태 점, 본문, 휴지통 삭제, 연필 초안
  되돌리기, "지금 보내기" ↵ = `stop()`) — `swift build` 통과로 확인

## 3. 검증

- [x] 3.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 3.2 수동 확인: 스트리밍 중 Enter → 캡션 표시·초안 비움 → 스트림
  종료 후 자동 전송, 대기 중 재Enter 무시·초안 유지, stop으로 끝나도
  자동 전송

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-queue-input-during-stream/`로 이동
