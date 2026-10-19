# Proposal

## Why

명령 메시지 접힌 카드가 헤더만 있어 내용 미리보기가 없다 — 접힌 상태에서
무엇이 전송되는지 파악할 수 없다.

## What Changes

- 접힌 카드에 메시지 앞 5줄 미리보기(작은 글씨, lineLimit 5)를 추가한다.
  5줄이면 명령 프롬프트의 지시부가 담기고 {previous} 대량 텍스트는 More로만
  열린다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 커스텀 슬래시 명령 — 접힌 카드 미리보기

## Impact

- `Sources/MenuBarChat/ContentView.swift` — 카드에 미리보기 한 줄 추가
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
