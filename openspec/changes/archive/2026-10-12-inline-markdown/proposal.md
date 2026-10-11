# Proposal

## Why

어시스턴트 답변이 평문 `Text`로만 표시되어 모델이 내보내는 굵게·기울임·
코드 범위·링크 강조가 원문 기호로 그대로 남는다.

## What Changes

- 어시스턴트 답변 말풍선을 인라인 마크다운(굵게, 기울임, `코드 범위`,
  링크) 스타일로 렌더링한다. 스트리밍 중에도 도착 즉시 반영.
- 블록 요소(코드 펜스, 목록, 제목)는 이번엔 스타일 없이 원문으로 둔다
  (무의존성 제약상 손제 블록 파서는 범위 밖).
- chat-conversation 스펙에 표시 요구사항 추가.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 어시스턴트 말풍선 인라인 마크다운 렌더링 요구사항
  추가

## Impact

- `Sources/MenuBarChat/ContentView.swift` — MessageView 답변 텍스트 교체
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
