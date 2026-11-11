# Proposal

## Why

statusItem에 autosaveName이 없어 재실행마다 macOS가 메뉴 막대 위치를
재배정한다 — Hidden Bar 같은 위치 기반 관리 앱을 쓰면 아이콘이 숨김
영역으로 밀려 "프로세스는 살았는데 안 보이는" 상태가 반복된다(실사용
관찰).

## What Changes

- statusItem.autosaveName을 지정해 사용자가 배치한 슬롯을 재실행 후에도
  유지한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

(없음 — 안정성 수정, skip_specs)

## Impact

- `Sources/MenuBarChat/MenuBarChatApp.swift` — 한 줄
