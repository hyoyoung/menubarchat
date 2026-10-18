# Tasks

- [x] 1.1 ChatModel: 명령 전개 메시지의 페이지 묶음에 ID 1개 부여(메시지
  수준 저장, 페이지 개별 ID 미부여), MessageView 미리보기를 단일 목록
  카드(`ID · N sources` + 도메인 목록, 실패 줄 오류, 썸네일 없음)로
  교체 — `swift build` 통과로 확인
- [x] 1.2 PromptComposer: 명령 메시지의 히스토리 스텁을 묶음 ID 1줄로,
  묶음 ID 언급 시 재포함하지 않도록 제외 — `swift build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: `/news` → 카드 1장(ID 1개 + 도메인 4줄), 추론
  라벨이 그 ID와 일치, 묶음 ID 언급 시 재포함 없음, 일반 URL 메시지는
  기존 미리보기·재포함 유지

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-command-source-list/`로 이동
