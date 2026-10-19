# Tasks

- [x] 1.1 PromptComposer windowing: 마지막 메시지가 URL-only면
  transcript를 그 메시지(+지시문)만으로 구성(과거 사용자 메시지 제외) +
  SelfTest(밀폐·혼합 메시지는 전체 맥락 유지) — selftest 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: `/news` 실행 후 URL 하나 전송 — 요약이 새 URL에만
  집중(과거 소스 언급 없음), URL+텍스트 혼합은 맥락 유지, 토큰 소비량
  표시에서 요청 토큰 감소 확인

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-bare-url-hermetic-request/`로 이동
