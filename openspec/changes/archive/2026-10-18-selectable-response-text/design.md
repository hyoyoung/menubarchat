# Design

## Context

SwiftUI Text + .textSelection의 선택 레이아웃은 긴 단일 attributed
문자열에서 프레임을 잃는다(blank-bubble 관찰). AppKit NSTextView는
선택을 TextKit이 처리하므로 그 경로가 없다. 마크다운 파이프라인은
AttributedString을 이미 만들고 있고 macOS 13+는 NSAttributedString
변환기를 제공한다.

## Goals / Non-Goals

**Goals:**

- 답변 말풍선의 네이티브 선택(드래그·단어·Cmd+C) — 공백 버블 재현 없음

**Non-Goals:**

- 사용자/붙여넣기 말풍선 선택, 서식 있는 붙여넣기, 링크 클릭 열기

## Decisions

### D1: SelectableTextView — NSViewRepresentable 1개

`makeUIView`: NSTextView(documentView: NSTextStorage) — isEditable
false, isSelectable true, drawsBackground false, textContainerInset
.zero, isRichText false. `updateUIView`: NSAttributedString(기존
markdown AttributedString 변환)을 textStorage에 set — 매 업데이트 재설정
(스트리밍 델타 포함). 색상은 라벨 색 기본(다크 모드 대응은 시스템
기본에 맡김).

### D2: 높이 — 높이 고정 폭 측정

말풍선 폭이 SwiftUI 레이아웃으로 결정되므로 representable에
container 폭을 전달해 `boundingRect`로 필요 높이를 재고
`frame(height:)`로 반영( GeometryReader 없이 제안 폭 사용). 측정은
textStorage 갱신 시 수행.

### D3: 적용 범위 — 어시스턴트 본문만

사용자·붙여넣기·추론은 기존 Text 유지(공백 버블 이력도 답변 본문이
원인이었음). 복사 버튼·기존 시나리오 무변경.

## Risks / Trade-offs

- [스트리밍 재변환 비용] 기존 markdown 파싱과 동급 — 배치 없이 진행.
- [높이 측정 오차(줄바꿈 경계)] 수동 확인(2.2)에서 긴 다이제스트로
  검증, 필요 시 inset 보정.

## Migration Plan

1. SelectableTextView 구현 + 답변 본문 교체 → build/selftest/all-build →
수동(드래그·더블클릭·Cmd+C·공백 재현 없음·스트리밍 갱신·다크 모드)
