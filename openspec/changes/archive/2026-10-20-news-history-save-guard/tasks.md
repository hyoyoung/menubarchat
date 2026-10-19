# Tasks

- [x] 1.1 saveNewsHistoryIfNeeded에 "명령 메시지에 오류 없는 페이지 1개
  이상" 조건 추가 — `swift build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 정상 /news는 이력 저장 유지, (네트워크 차단 등으로)
  fetch 전무한 실행의 응답은 이력 파일에 남지 않음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-news-history-save-guard/`로 이동
