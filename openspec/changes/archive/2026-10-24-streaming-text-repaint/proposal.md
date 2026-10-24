# Proposal

## Why

SelectableTextView(NSTextView 래핑)가 스트리밍 중 백지 화면을 유발한다
(실사용 관찰 — URL 요약 응답 스트리밍에서 리스트 전체가 백지, 스크롤하면
복구). 결함 둘: ① sizeThatFits가 `glyphRange(for:)`만으로 레이아웃 완료
없이 usedRect를 읽어 잘못된 높이를 SwiftUI가 캐시 ② updateNSView가 텍스트
교체 후 다시 그리기를 요청하지 않음.

## What Changes

- sizeThatFits에서 측정 전 `layoutManager.ensureLayout(for:)` 호출로
  레이아웃 완료를 보장한다.
- updateNSView에서 텍스트 교체 후 `needsDisplay`·`needsLayout`를 true로
  지정해 스트리밍 델타마다 다시 그리기를 명시한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

(없음 — 렌더링 결함 수정, skip_specs)

## Impact

- `Sources/MenuBarChat/ContentView.swift` — SelectableTextView 두 군데
