# Tasks

## 1. 순수 파서 + 테스트

- [x] 1.1 PageFetcher에 순수 static helper 추가: YouTube 동영상 ID
  추출(watch?v=, youtu.be), watch HTML에서 captionTracks 배열 추출,
  트랙 선택(D2 규칙), json3 이벤트 → 자막 텍스트 조립 — `swift build`
  통과로 확인
- [x] 1.2 SelfTest에 파서 테스트 추가: ID 추출 형식 3종, 언어/수동
  우선 선택, json3 조립, 자막 없음 케이스 — `swift run MenuBarChat
  --selftest` 전부 통과로 확인

## 2. fetchPage 연결

- [x] 2.1 `fetchPage`에 YouTube 분기 추가(자막 경로 → FetchedPage,
  실패 → D3 오류 매핑) — `swift build` 통과로 확인
- [x] 2.2 og 메타 파서 일반화(`metaContent`) + 메타데이터 폴백 구현
  ("Video metadata (no captions): <제목>" 마커, 메타데이터도 없으면
  "no content") — `swift build` 및 selftest 통과로 확인

## 3. 검증

- [x] 3.1 `./openspec-all-build.sh` 통과
- [x] 3.2 수동 확인: 자막 있는 YouTube URL → 자막 기반 미리보기 +
  지시문 요약 답변, 자막 없는 영상 → "Video metadata (no captions):"
  마커의 메타데이터 요약, 일반 URL 회귀 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-youtube-transcript-fetch/`로 이동
