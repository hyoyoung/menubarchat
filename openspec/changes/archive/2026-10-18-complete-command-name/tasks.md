# Tasks

- [x] 1.1 `ChatModel.applyCommand`를 이름 완성으로 교체: 초안의 첫 `/…`
  토큰을 `/<명령이름> `로 치환(잔여 초안 유지) — `swift build` 통과로
  확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: `/ne` → Tab 또는 드롭다운 클릭 → 초안이 `/news `
  로 완성(프롬프트 노출 없음), 그대로 Enter → 프롬프트 전개 전송,
  미등록 `/foo` 원문 전송 회귀 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-complete-command-name/`로 이동
