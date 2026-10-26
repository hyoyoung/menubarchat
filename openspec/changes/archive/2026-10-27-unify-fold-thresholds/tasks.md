# Tasks

- [x] 1.1 추론 needsFold에 100자 초과 조건 추가 — `swift build` 통과으로
  확인
- [x] 1.2 붙여넣기 카드 분기 확장: pasteID > 0 또는 (일반 사용자 텍스트
  && 줄바꿈 > 5 || 100자 초과)도 같은 카드로 접힘(첨부 아닌 경우 ID 없는
  라벨) — `swift build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 6줄 텍스트 전송 — ID 없는 접힌 카드·전송 내용은
  일반 메시지(URL fetch 무변경), 10줄+ 붙여넣기·명령·추론은 기존대로,
  짧은 추론(5줄·100자 이하)은 펼침

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-unify-fold-thresholds/`로 이동
