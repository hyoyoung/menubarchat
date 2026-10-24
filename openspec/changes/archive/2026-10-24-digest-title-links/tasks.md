# Tasks

- [x] 1.1 PageFetcher: `filteredAnchors(raw:base:)` 순수 함수(절대화·
  프래그먼트 제외·중복 제거·빈 제목 제외·상한 40) + 정적 HTML 정규식·
  렌더 DOM 배열 양 경로 수집 + SelfTest — selftest 통과으로 확인
- [x] 1.2 PromptComposer: 명령 다중 페이지 첨부에 발췌 뒤 "Links:"
  목록 부착 — `swift build` 통과으로 확인
- [x] 1.3 내장 news 프롬프트에 항목 서식 지시(`**[Title](URL)** —
  summary`, URL 불확실 시 `*Title* — summary` 기울임·링크 없음, Links
  외 URL 금지) + SelfTest 기대값 — selftest 통과으로 확인
- [x] 1.4 SelectableTextView: .link 범위의 전경색 labelColor·밑줄
  제거 덮어쓰기 — `swift build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: /news — 제목이 굵고 링크 클릭 시 브라우저에서 해당
  기사가 열리는지, 링크 없는 항목은 링크 없이, 드래그 선택·복사 유지,
  잘못된 URL 연결(오탐) 눈으로 확인

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-digest-title-links/`로 이동
