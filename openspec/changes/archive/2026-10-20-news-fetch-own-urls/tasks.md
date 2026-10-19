# Tasks

- [x] 1.1 send()에서 {previous} 주입 전 프롬프트로 fetch 대상을 계산해
  Message.pageTargets로 전달·저장(큐 경유 포함), fetch가 명령 메시지에서
  pageTargets를 사용하도록 분기 — `swift build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 이력 있는 상태에서 /news — fetch가 정확히 4개(진행
  문구 4/N, 소스 카드 4줄)이고 이력의 기사 URL이 수집되지 않는지

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-news-fetch-own-urls/`로 이동
