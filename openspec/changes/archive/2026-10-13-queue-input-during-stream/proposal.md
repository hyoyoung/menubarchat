# Proposal

## Why

응답이 스트리밍되는 동안 입력이 완전히 무시되어, 생각이 이어질 때
사용자가 답변 완료를 기다렸다 다시 입력해야 한다. 스트리밍 중 입력을
최대 1개 대기시키고 스트림 종료 직후 자동 전송하면 대기가 사라진다.

## What Changes

- 스트리밍 중 Enter를 누르면 메시지를 대기열(단일 슬롯)에 넣고 초안을
  비운다. 대기 메시지는 스트림이 끝나는 즉시 자동 전송된다.
- 대기 중 다시 Enter를 누르면 무시하고 초안을 유지한다(텍스트 손실 없음).
- 대기 메시지가 있으면 입력란 위에 대기 패널을 표시한다: 개수("대기
  메시지 1개")와 전체 해제(⌥⌘⌫), 항목에는 즉시 전송(↵, 현재 응답을
  끊고 바로 전송), 삭제(휴지통), 초안 되돌리기(연필 — 대기 텍스트를
  초란으로 가져가 해제)를 제공한다.
- 중단(stop)으로 스트림이 끝나도 대기 메시지는 그대로 자동 전송된다
  (대기를 임의로 버리지 않는다). 취소 UI는 이번 범위 밖.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 메시지 전송 — 스트리밍 중 입력 무시에서 단일
  대기열 자동 전송으로 수정

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — 대기 상태 + send 분리 + 자동
  전송
- `Sources/MenuBarChat/ContentView.swift` — 대기 패널(헤더·항목 액션·
  단축키)
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
