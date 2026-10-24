# Proposal

## Why

요약형 요청의 사고 수준 medium 오버라이드(summarize-requests-medium)를
되돌린다 — 모든 요청이 설정의 사고 수준을 그대로 따르는 게 사용자
판단으로 낫다.

## What Changes

- effectiveThinkingBudget 오버라이드 제거 — stream()은 항상 설정의
  사고 수준을 사용한다. (URL-only·긴 붙여넣기·뉴즈 전부 설정값)

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 기본 지시문 — 사고 수준 조항 제거(되돌림)

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — 오버라이드 제거
- `Sources/MenuBarChat/PromptComposer.swift` — isURLOnlyMessage 래퍼 제거
- SelfTest — 사고 수준 검사 2건 제거
