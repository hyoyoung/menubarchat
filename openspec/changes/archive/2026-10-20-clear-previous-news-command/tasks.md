# Tasks

- [x] 1.1 NewsHistory.clear() 추가, builtinCommands에 `clear-previous-news`
  (빈 프롬프트) 등록, send() 가로채에서 이력 비움 + 확인 말풍선 — `swift
  build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: /news 실행(이력 생성) → `/clear-previous-news` →
  확인 말풍선·이력 파일 비어 있음 → 다음 /news 전개에 {previous}=none,
  /cl 자동완성, /previous-news는 안내 말풍선

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-clear-previous-news-command/`로 이동
