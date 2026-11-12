# Proposal

## Why

"전송 시 바닥 팔로우 재개"가 sendNow 내부에 있어 대기열 자동 전송(스트림
종료 후 드레인)에도 적용된다 — 사용자가 위로 올라가 읽던 위치가 자동
전송 순간마다 바닥으로 점프해 버린다(실사용 관찰). 자동 전송은 "사용자가
보낸 순간"이 아니므로 재개 규칙이 확장돼서는 안 된다.

## What Changes

- followsBottom 재개를 sendNow에서 제거하고 사용자 직접 행동 경로로
  이동: send()(Enter·전송 버튼)와 sendQueuedNow(지금 보내기).
  대기열 드레인은 followsBottom을 건드리지 않는다 — 팔로우 중이면
  계속 따라가고, 읽고 있었으면 위치를 유지한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 메시지 전송 — 자동 전송은 재개하지 않음

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — 재개 시점 이동
- SelfTest — 해당 없음(뷰 동작), 수동 검증
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
