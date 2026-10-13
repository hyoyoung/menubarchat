# Tasks

## 1. 표시

- [x] 1.1 ContentView 기록 목록 끝에 조건부 대기 자리 추가
  (`isStreaming && !isFetchingPage && 마지막 메시지가 어시스턴트 아님`,
  어시스턴트 말풍선 스타일 + ProgressView small) — `swift build` 통과로
  확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 전송 직후 스피너 자리 표시 → 첫 토큰과 함께 실제
  답변으로 교체, URL 메시지는 "페이지 가져오는 중…" 후 대기 자리로
  이어짐, 오류 시 오류 말풍선으로 전환

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-response-placeholder/`로 이동
