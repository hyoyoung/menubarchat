# Tasks

- [x] 1.1 filteredAnchors에 외부-호스트 필터 추가(페이지 호스트와 다른
  URL만 남김) + SelfTest(같은-호스트 내비 제외·외부 유지) — selftest
  통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: /news — 링크 커버리지 추가 상승(HN 스토리 전부
  후보화), 무링크 항목 감소·클릭 정상

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-digest-story-anchors/`로 이동
