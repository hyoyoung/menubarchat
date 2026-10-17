# Tasks

## 1. 모델

- [x] 1.1 Message에 `cachedMarkdown`·`cachedImage` 추가 + 캐시 제외
  커스텀 Equatable, sendNow에서 썸네일 1회 디코드 저장, stream() 종료
  시 마지막 답변 markdown 캐시 확정 — `swift build` 통과로 확인

## 2. 뷰

- [x] 2.1 MessageView Equatable 채택 + 사용부 `.equatable()`,
  markdown·썸네일 렌더가 캐시 우선 사용 — `swift build` 통과로 확인

## 3. 검증

- [x] 3.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 3.2 수동 확인: 긴 대화(20턴 수준)에서 스크롤·패널 숨김/표시
  체감 개선, 스트리밍 중 스타일 실시간 유지, 썸네일·markdown 표시
  무변경

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-message-render-cache/`로 이동
