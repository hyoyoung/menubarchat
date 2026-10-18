# Tasks

- [x] 1.1 builtinCommands에 `previous-news`(빈 프롬프트) 등록 — `swift
  build` 통과로 확인
- [x] 1.2 send() 전개 분기에서 "previous-news" 가로채: 이력 최신 항목
  어시스턴트 말풍선 삽입(마크다운 즉시 확정), 비었으면 안내 말풍선,
  스트림 미진입 — `swift build` 통과로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: `/news` 실행 후 `/previous-news` → 즉시 같은
  다이제스트 재표시(요청 없음·복사 버튼 동작), 이력 비운 상태에서는
  안내 말풍선, `/pre` 자동완성·Tab 동작, 일반 명령 회귀 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-previous-news-command/`로 이동
