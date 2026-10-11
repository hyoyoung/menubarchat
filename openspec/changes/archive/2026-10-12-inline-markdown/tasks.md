# Tasks

## 1. 렌더링 교체

- [x] 1.1 MessageView의 어시스턴트 답변 Text를 `AttributedString(markdown:)`
  기반으로 교체 (파싱 실패 시 원문 폴백) — `swift build` 통과로 확인

## 2. 검증

- [x] 2.1 `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 굵게/기울임/코드 범위/링크 렌더링, 스트리밍 중 반영,
  일반 텍스트·사용자 말풍선 회귀 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-inline-markdown/`로 이동
