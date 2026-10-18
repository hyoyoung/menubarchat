# Tasks

- [x] 1.1 SettingsStore: `defaultCommands`를 `builtinCommands`로 개명,
  `availableCommands`(기본 + 비충돌 사용자 명령) 계산 추가 + SelfTest
  (병합·이름 충돌 시 기본 우선·기본 단독) — selftest 통과으로 확인
- [x] 1.2 호출부(ChatModel send·applyCommand, 드롭다운·Tab)를
  `availableCommands`로 교체 — `swift build` 통과으로 확인
- [x] 1.3 편집기 분할: 기본 명령 읽기 전용 표시(배지) + 사용자 명령
  편집기 — `swift build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 기본 news가 최신 프롬프트(저장본 무시), 사용자가
  만든 명령은 유지·편집·삭제 가능, 같은 이름 저장 시 기본이 우선,
  드롭다운에 기본+사용자 모두 표시

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-builtin-commands-refresh/`로 이동
