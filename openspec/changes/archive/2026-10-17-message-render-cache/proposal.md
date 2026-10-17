# Proposal

## Why

긴 대화에서 스크롤과 패널 숨김/표시가 느리다. 원인: MessageView.body가
실행될 때마다 (스트리밍 델타 하나에도) 보이는 모든 메시지의 markdown
AttributedString 재파싱과 썸네일 JPEG 재디코드가 반복된다.

## What Changes

- 변화 없는 메시지의 렌더 스킵: MessageView에 `.equatable()` 적용
  (Message가 이미 Equatable — 캐시 필드 제외 커스텀 ==).
- 완성된 답변의 markdown 1회 파싱 캐시: 스트리밍 중엔 기존대로 라이브
  파싱(마지막 메시지 1개뿐이라 저렴), 스트림 종료 시 Message에 캐시.
- 썸네일 NSImage 디코드 캐시: Message에 1회 디코드 저장.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

(없음 — 동작·표시 무변경, 성능만. `.openspec.yaml`에 `skip_specs: true`)

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — Message 캐시 필드 + 커스텀
  Equatable, 스트림 종료 시 캐시 확정
- `Sources/MenuBarChat/ContentView.swift` — MessageView Equatable +
  `.equatable()`, 캐시 사용
- 표시 결과는 동일 (markdown 스타일·썸네일 변화 없음)
