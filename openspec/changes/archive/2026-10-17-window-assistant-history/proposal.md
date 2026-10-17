# Proposal

## Why

매 요청마다 과거 어시스턴트 답변 전문이 재전송되어 긴 대화에서 요청
토큰이 누적 증가한다(20턴 ≈ 요청마다 ~1만 토큰).

## What Changes

- 요청에서 어시스턴트 답변은 **직전 1개만** 포함하고 더 오래된 답변은
  전송에서 제외한다(스텁·색인 없음). 사용자 메시지는 전부 유지한다.
- 첨부 스텁(`ID<n>`/`ID<n>p`/`ID<n>i`)과 언급 재포함은 마지막 메시지
  부착 방식이라 그대로 동작한다.
- 표시는 무변경 — 화면의 대화는 전문 그대로, 요청만 절약한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `llm-provider`: chat completions 요청 — messages 구성 규칙 변경

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — stream()의 contents 구성 필터
- `Sources/MenuBarChat/PromptComposer.swift` — 전사(transcript) 조립
  순수 함수화 + SelfTest
- `openspec/specs/llm-provider/spec.md` — 요구사항 1건 (아카이브 시 반영)
