# Tasks

- [x] 1.1 대기 문구 분기 추가: `isFetchingPage`가 끝난 뒤(또는 가져올
  페이지 없음)에도 첫 답변 델타 전이면 "답변 생성 중…" 표시 — `swift
  build` 통과로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: `/news` 실행 — fetch 문구(n/N) 이후 "답변 생성 중…"
  로 이어지고 첫 답변 델타와 함께 사라짐, 일반 텍스트 전송에서도
  "답변 생성 중…" 표시

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-answer-wait-label/`로 이동
