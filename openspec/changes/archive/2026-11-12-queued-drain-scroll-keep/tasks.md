# Tasks

- [x] 1.1 followsBottom = true를 sendNow에서 send()/sendQueuedNow로
  이동(드레인 경로는 무건드림) — `swift build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 스트리밍 중 메시지 대기 → 위로 스크롤해 읽기 →
  스트림 종료로 자동 전송 — 위치 유지, Enter 직접 전송은 여전히 바닥
  재개, "지금 보내기"도 재개

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-queued-drain-scroll-keep/`로 이동
