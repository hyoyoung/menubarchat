# Proposal

## Why

`{previous}` 주입이 직전 다이제스트 원문(마크업 포함)을 실어, 서식 지시
("제목 항상 굵게")보다 예시 모방이 이겨 옛 서식(기울임 제목)이 세대를
타고 복제된다 — 최신 프롬프트로 실행해도 기울임 13개 잔존(15:56 실행
원문 확인).

## What Changes

- `NewsHistory.previousContext`가 주입 직전 마크업을 제거한다 — 강조
  기호(`**`·`*`) 삭제, `[제목](url)`을 제목 텍스트로 풀기. 이력 주입의
  목적(이미 다룬 기사 식별)에는 제목 텍스트만 필요하다. 프롬프트 서식
  지시는 그대로 — 서식 견본 경쟁자가 사라진다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 뉴스 다이제스트 이력 — 평문 주입 명시

## Impact

- `Sources/MenuBarChat/NewsHistory.swift` — previousContext 살균
- SelfTest — 살균 회귀
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
