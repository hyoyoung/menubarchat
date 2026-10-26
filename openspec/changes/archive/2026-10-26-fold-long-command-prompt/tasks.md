# Tasks

- [x] 1.1 MessageView 명령 접힘 조건 교체: `isLongPaste || text.count >
  100` (줄바꿈 5 초과·100자 초과 기준) — `swift build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 이력 없는 첫 /news 전개도 접힌 카드(+앞 5줄
  미리보기), More 펼침·ID 라벨·fetch 정상, 100자 미만 짧은 명령은 전문

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-fold-long-command-prompt/`로 이동
