# Proposal

## Why

바닥 팔로우의 이동 명령(scrollTo)이 마지막 "메시지"에 핀을 고정하는데,
대기 표시(스피너·문구) 행은 그 아래에 있다. 팔로우 판정(하단 마커)은
진짜 끝을 보므로, 대기 표시가 보이는 동안 사용자가 바닥으로 스크롤해도
다음 델타의 scrollTo가 스피너 한 칸 위로 끌어올린다(매 델타 반복).

## What Changes

- 대기 표시 행에 id를 부여하고, 대기 표시가 화면에 있는 동안의 자동
  스크롤 대상을 마지막 메시지가 아니라 대기 표시 행으로 한다 — 팔로우
  판정(마커)과 이동 목적지가 일치하여 점프가 사라진다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 스트리밍 표시 — 바닥 팔로우가 대기 표시를 포함한
  끝까지 고정

## Impact

- `Sources/MenuBarChat/ContentView.swift` — 대기 행 id + scrollTo 대상
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
