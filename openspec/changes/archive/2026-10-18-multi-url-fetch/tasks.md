# Tasks

## 1. 토큰 경제

- [x] 1.1 PromptComposer에 `excerpts(pages:)` 발췌·예산 헬퍼(페이지당
  4천 자, 합계 2만 자 비례 축소, 최소 500자) + SelfTest 3건(단일 발췌,
  합계 상한, 비례 축소) — selftest 통과로 확인

## 2. 다중 fetch

- [x] 2.1 ChatModel: `viaCommand` 플래그(send 전개 시 표시), 명령 전개
  메시지의 URL 전부(상한 10개)를 슬라이딩 2창 TaskGroup으로 fetch,
  페이지별 ID 부여·오류 표시 (일반 메시지는 기존 첫 URL 1개 유지) —
  `swift build` 통과로 확인
- [x] 2.2 마지막 메시지 페이지 첨부를 발췌 헬퍼 결과로 교체(명령 전개
  메시지에만 적용, 일반 메시지 전문 유지·언급 재포함 전문 무변경) —
  `swift build` 통과로 확인
- [x] 2.3 플레이스홀러 문구 개수 표시("페이지 N개 가져오는 중…") —
  `swift build` 통과로 확인

## 3. 검증

- [x] 3.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 3.2 수동 확인: `/news` 전송 → 4개 사이트 fetch(일반 URL 메시지는 첫 1개만·전문 첨부 회귀 확인),(미리보기 4개,
  "페이지 4개 가져오는 중…") → 다이제스트 요청 토큰 유의미하게 감소
  확인, "ID<n> 자세히" → 전문 재포함 정상, 단일 URL 회귀 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-multi-url-fetch/`로 이동
