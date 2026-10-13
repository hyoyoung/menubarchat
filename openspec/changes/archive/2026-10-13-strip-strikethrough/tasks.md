# Tasks

## 1. 구현

- [x] 1.1 `MessageView.markdown`에 파싱 후 `.strikethrough` 인텐트 제거
  루프 추가 — `swift build` 통과로 확인

## 2. 테스트

- [x] 2.1 SelfTest 추가: `MessageView.markdown("a ~~b\nc~~ d")`의 모든
  런에 strike 인텐트 없음, `MessageView.markdown("**굵게** ~~x~~")`의
  굵게 유지 — `swift run MenuBarChat --selftest` 통과로 확인

## 3. 검증

- [x] 3.1 `./openspec-all-build.sh` 통과
- [x] 3.2 수동 확인: 모델에 `~~` 포함 답변을 요청해 취소선 미발생,
  굵게/기울임/코드 범위 정상

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-strip-strikethrough/`로 이동
