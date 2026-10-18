# Tasks

- [x] 1.1 대기 문구를 진행 카운트로 교체: 다중 fetch 중 "페이지
  n/N 가져오는 중…"(n = 마지막 사용자 메시지의 pages 수, N =
  fetchingPageCount, 캡) — `swift build` 통과로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: `/news` 실행 중 문구가 1/4 → 2/4 … 로 갱신,
  단일 URL은 기존 문구 유지

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-fetch-progress-label/`로 이동
