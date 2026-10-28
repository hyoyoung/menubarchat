# Tasks

- [x] 1.1 scrollToBottom의 scrollTo를 DispatchQueue.main.async로 지연 +
  ScrollView에 .scrollBounceBehavior(.basedOnSize) 추가 — `swift build`
  통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: URL 입력 — 페치·미리보기 삽입 중 바운스·백지
  오퍼슛 없음, 스트리밍 중 바닥 핀·재개·점프 버튼 회귀 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-fetch-scroll-overshoot/`로 이동
