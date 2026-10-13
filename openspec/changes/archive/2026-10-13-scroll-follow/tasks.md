# Tasks

## 1. 모델·모니터

- [x] 1.1 ChatModel에 `@Published var followsBottom = true` 추가,
  `sendNow`에서 재개 — `swift build` 통과로 확인
- [x] 1.2 AppDelegate 모니터에 `.scrollWheel` 추가(패널 키윈도우 + 위
  방향 → `chat.followsBottom = false`, 이벤트는 반환) — `swift build`
  통과로 확인

## 2. 뷰

- [x] 2.1 ContentView: 자동 스크롤을 `followsBottom` 조건부로 교체,
  GeometryReader 하단 도달 감지(40pt), 점프 버튼 overlay 추가 —
  `swift build` 통과로 확인

## 3. 검증

- [x] 3.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 3.2 수동 확인: 스트리밍 중 위로 스크롤 → 위치 유지·점프 버튼
  표시, 버튼 → 즉시 맨아래·자동 스크롤 재개, 맨아래까지 직접 스크롤해도
  재개, 메시지 전송 시 재개, 팔로우 중 화면이 끌려가는 기존 동작 유지

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-scroll-follow/`로 이동
