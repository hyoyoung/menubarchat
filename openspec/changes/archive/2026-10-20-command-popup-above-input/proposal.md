# Proposal

## Why

명령 드롭다운이 `.overlay(alignment: .top)`로 입력창을 덮으며 아래로
그려져 입력 텍스트를 가린다. 스펙("입력창 위 드롭다운")과 불일치하는
구현 버그다.

## What Changes

- 드롭다운 overlay 정렬을 `.bottom`으로 바꿔 입력창 **위**에 떠서
  표시한다. 동작(자동완성·Tab·선택)은 무변경. 스펙 변경 없음(skip_specs).

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

(없음 — 기존 "입력창 위 드롭다운" 명세로의 복귀)

## Impact

- `Sources/MenuBarChat/ContentView.swift` — 정렬 한 단어
