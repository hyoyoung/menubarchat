# Design

## Context

다이제스트(/news)는 여러 홈페이지의 헤드라인을 필요로 하고, 토큰 비용은
요청에 실은 텍스트 양으로 결정된다. 첨부를 헤드라인 수준 발췌로 줄이고
심화(전문)는 언급 재포함으로 선택적으로 제공한다. 상한은 개수(10)보다
출력(합계 2만 자)이 정직한 제동이다.

## Goals / Non-Goals

**Goals:**

- 명령 전개 메시지의 URL 전부 fetch(동시 2) + 발췌 첨부 + 전문은 재포함으로
- 일반 메시지는 기존 단일 URL fetch·전문 첨부 무변경

**Non-Goals:**

- 사이트별 헤드라인 추출기, 요약본의 저장·영속화, 개수·예산 설정화

## Decisions

### D0: 명령 전개 판정 — Message에 `viaCommand` 플래그

`send()`에서 전개가 일어났으면 sendNow를 거쳐 마지막 사용자 메시지에
`viaCommand = true` 표시. fetch 분기(다중 vs 단일)와 발췌 적용 여부가
이 플래그로 결정된다. `==` 비교에 포함(의미 상태).

### D1: 슬라이딩 2창 — TaskGroup + 투입 큐

URL 목록을 큐로 두고 TaskGroup에 항상 최대 2개가 떠 있도록 완료 시
보충. 반 쪽 분할(rigid)보다 느린fetch 하나가 전체를 막지 않는다. 11번째
URL은 큐에 넣지 않는다(무시).

### D2: 발췌·예산 — PromptComposer 순수 헬퍼

`excerpts(pages:) -> [(FetchedPage, String)]`: 각 페이지 앞 4천 자
발췌 후 합계가 2만 자 초과면 각 발췌를 비례 축소(최소 500자). 마지막
메시지 첨부는 이 결과만 실고, `Message.pages`의 전문은 원본 그대로
보관 — 재포함 경로(언급)는 기존 전문 로직 무변경. SelfTest로
발췌 길이·합계 상한·비례 축소를 고정한다.

### D3: YouTube·오류 — URL별 기존 분기 재사용

fetchPage의 URL 분기(일반 페이지/YouTube 자막)를 URL별로 그대로
호출. 오류 페이지는 첨부·발췌에서 제외되는 기존 규칙 유지.

### D4: 플레이스홀러 개수 문구

`fetchingPageCount` Published 추가(0=미가져오기). 문구는 개수 2 이상
"N개". isFetchingPage를 대체하지 않고 함께 둔다(문구 조건만 개수로).

## Risks / Trade-offs

- [발췌 4천 자가 헤드라인을 놓칠 수 있음] — 홈페이지 상단 배치 관행상
  드묾. 놓치면 사용자가 ID 재포함으로 전문 확인 가능.
- [무거운 페이지 10개 병렬 fetch의 일시적 메모리] — 2창 제한이 완화.

## Migration Plan

1. excerpts() 헬퍼 + SelfTest → 2. ChatModel 다중 fetch 루프(2창) +
개수 표시 → 3. apiContent 발췌 적용 → build/selftest/all-build →
수동(/news 4사이트 다이제스트, ID 재포함 전문 확인)
