# Tasks

- [ ] 1.1 MessageView: viaCommand && 10줄 초과 메시지를 접힌 카드
  ("명령 /이름 · N줄") + More/Less(isTextExpanded 재사용)로 표시 —
  `swift build` 통과으로 확인

## 2. 검증

- [ ] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [ ] 2.2 수동 확인: 이력 있는 상태에서 /news — 명령 말풍선이 접힌
  카드, More로 전문({previous} 포함) 확인, fetch·소스 카드·다이제스트
  정상, 10줄 이하 첫 실행은 전문 그대로

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-fold-long-command-messages/`로 이동
