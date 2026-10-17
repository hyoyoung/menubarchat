# Tasks

## 1. 조립

- [x] 1.1 `PromptComposer.transcript(messages:urlHandling:)` 추가(사용자
  전부 + 마지막 어시스턴트 1개, apiContent·이미지 파트 재사용) +
  SelfTest 3건(마지막 답변만·사용자 전부·순서 유지) — selftest 통과로
  확인
- [x] 1.2 `ChatModel.stream()`이 transcript()를 사용하도록 교체 —
  `swift build` 통과로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 긴 대화에서 전송 동작·직전 후속 질문 응답 정상,
  `ID<n>` 언급 재포함 유지, 토큰 소비량 표시가 이전 요청보다 작아짐

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-window-assistant-history/`로 이동
