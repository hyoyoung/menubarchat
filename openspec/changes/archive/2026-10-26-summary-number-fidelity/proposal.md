# Proposal

## Why

요약이 숫자를 병합·변형한다 — 원문 "a 20 or a 30"이 "2030점"으로 요약된
사례(The Register IBM 기사, 실사용 관찰). 추출·렌더는 무결하며 모델
파라프레이즈의 숫자 충실도 문제다.

## What Changes

- 요청 system 서두(고정)에 숫자 충실도 문장 추가: "Reproduce numbers,
  ranges, and figures exactly as written in the data — never merge or
  alter digits."

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 기본 지시문 — 서두에 숫자 충실도

## Impact

- `Sources/MenuBarChat/PromptComposer.swift` — untrustedPreamble 문장
- SelfTest — 서두 기대값 갱신
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
