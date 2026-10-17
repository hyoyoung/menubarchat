# Proposal

## Why

Tab 완성이나 드롭다운 선택이 프롬프트 전문으로 초안을 덮어써서 입력창이
순식간에 긴 텍스트로 바뀐다. 셸 자동완성 관례처럼 **명령 이름만 완성**되는
편이 자연스럽다 — 프롬프트는 전송 시점에 전개된다(기존 동작).

## What Changes

- Tab 완성·드롭다운 선택 모두 초안의 `/…` 토큰을 완성된 `/명령이름`으로
  바꾼다(뒤에 공백). 프롬프트 전개는 전송 시점에만 일어난다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 커스텀 슬래시 명령 — 선택/Tab의 결과가 이름
  완성으로 변경

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — applyCommand → 이름 완성으로
  교체 (수 줄)
- SelfTest — 없음(순수 함수 무관) 또는 완성 문자열 헬퍼 테스트
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
