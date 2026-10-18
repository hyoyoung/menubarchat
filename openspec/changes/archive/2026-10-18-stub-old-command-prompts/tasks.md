# Tasks

## 1. 모델

- [x] 1.1 Message에 `commandName: String?` 추가(== 포함), send 전개·큐
  경유 시 저장 — `swift build` 통과로 확인

## 2. 조립

- [x] 2.1 PromptComposer apiContent 비-마지막 분기: `commandName`이 있는
  메시지는 텍스트를 `[Command: /<이름>]` 스텁으로 대체(페이지 스텁은
  기존대로) + SelfTest 2건(스텁화, 마지막 요청 전문 유지) — selftest
  통과로 확인

## 3. 검증

- [x] 3.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 3.2 수동 확인: `/news` 실행 → 다른 URL 하나 붙여넣어 전송 → 해당
  URL만 요약(전체 소스 재요약 아님), 이후 요청 토큰 소비 감소, 화면
  표시 무변경

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-stub-old-command-prompts/`로 이동
