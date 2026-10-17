# Proposal

## Why

`/news` 같은 다이제스트가 여러 사이트를 종합하려면 메시지의 URL 전부를
가져와야 하는데, 현재 스펙은 첫 URL 1개만 fetch한다. 또한 페이지 전문
(2만 자)을 통째로 첨부해 다중 사이트에서 토큰이 선형 폭주한다.

## What Changes

- **명령으로 전개된 메시지**의 `http(s)` URL 전부를 fetch한다 — 상한
  10개(11번째부터 무시), 동시성은 슬라이딩 2창(2개 병렬, 완료 즉시 다음
  투입). 일반 사용자 메시지는 기존대로 첫 URL 1개만 fetch한다(대량
  fetch는 명령으로만 일어남).
- 토큰 경제(명령 전개 메시지에 적용): 마지막 메시지 첨부는 **페이지당
  앞 4천 자 발췌**로 실고 메시지 첨부 합계 상한 2만 자(초과 시 페이지별
  비례 축소). 전문은 보관하여 `ID<n>` 언급 재포함 때 전체를 다시 실는다.
  일반 메시지의 단일 URL 첨부는 기존 전문 방식 유지.
- 플레이스홀더 문구: 가져올 페이지가 2개 이상이면 "페이지 N개 가져오는
  중…"으로 개수를 표시한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 웹 페이지 읽기(다중 fetch·발췌 첨부·예산),
  첨부 ID 언급 재포함(페이지는 전문 재포함 명시), 응답 대기 표시(개수
  문구)

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — fetch 루프(TaskGroup 2창)
- `Sources/MenuBarChat/PromptComposer.swift` — 발췌·예산 순수 헬퍼
- SelfTest — 발췌·예산 회귀
- `openspec/specs/chat-conversation/spec.md` — 요구사항 3건 (아카이브 시
  반영)
