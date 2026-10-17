# Tasks

- [x] 1.1 MessageView가 `copiedMessageID`·`hoveredMessageID`를 저장
  프로퍼티로 받도록 변경, `==`에서 environment 접근 제거(저장 값만
  비교), 표시 판정도 저장 값 사용, 호출부에서 전달 — `swift build` 통과로
  확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 긴 텍스트 붙여넣기·전송·복사 체크마크·호버 공개
  정상, 크래시 없음 (5분 사용)

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-fix-equatable-crash/`로 이동
