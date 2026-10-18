# Tasks

- [x] 1.1 PageFetcher에 품질 판정 순수 함수(공백 접기·기호 조각 제거 후
  실내용 ≥200자 & 실내용 비율 ≥50%) 추가 + `isSufficientText` 교체,
  미리보기 첫 줄·발췌에도 정리 적용 + SelfTest(내비 숩 미달·실내용
  통과·기호 조각 제거) — selftest 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: `/news` 다이제스트에 네이버·CNN 헤드라인이 포함되는지
  확인 — 2초 렌더 캡로 부족하면 3초로 한 단계 조정 후 재확인, HN·BBC
  회귀 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-content-quality-fallback/`로 이동
