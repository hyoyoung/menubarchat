# Proposal

## Why

fetch 중 scrollTo가 아직 재료화되지 않은 가상 "placeholder" 행을 목표로
잡으면 SwiftUI가 추정 오프셋으로 잘못 점프한다(위로 지나치게 스크롤,
스트리밍 시작 후 복귀 — 실사용 관찰).

## What Changes

- scrollToBottom의 목표 선택: 마지막 메시지가 사용자면 그 실존 말풍선으로
  핀, 마지막이 빈 어시스턴트(스트리밍 시작 직후)일 때만 "placeholder"
  목표 유지.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

(없음 — 스크롤 신뢰성 수정, skip_specs)

## Impact

- `Sources/MenuBarChat/ContentView.swift` — scrollToBottom 목표 선택
