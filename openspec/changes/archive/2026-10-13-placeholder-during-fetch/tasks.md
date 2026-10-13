# Tasks

## 1. 통합

- [x] 1.1 ContentView 대기 말풍선에서 `!isFetchingPage` 조건 제거,
  `isFetchingPage`일 때 "페이지 가져오는 중…" 문구 추가, ForEach 안의
  기존 가져오기 표시 블록 제거 — `swift build` 통과로 확인

- [x] 1.2 대기 조건 확장: 마지막 어시스턴트 답변의 본문(text)이 비어
  있으면 추론 말풍선 아래 답변 자리에도 대기 표시 유지 — `swift build`
  통과로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: URL 전송 직후 스피너 말풍성 + 가져오기 문구 →
  fetch 후 문구 소멸(스피너 유지) → 추론 말풍선 아래 답변 자리 스피너 →
  첫 토큰과 함께 실제 답변으로 교체, 일반 메시지는 전송 직후 스피너
  말풍선

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-placeholder-during-fetch/`로 이동
