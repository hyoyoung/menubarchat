# Proposal

## Why

이미지 입력이 여전히 두 경로에서 실패한다: ① 드래그 앤 드롭은 처리기가
없어 macOS 기본 동작(텍스트 필드에 파일 경로 삽입)이 그대로 작동한다.
② 일부 캡처 흐름은 pasteboard에 fileURL 타입 없이 경로 문자열만 싣는데,
지난 수정의 판정(fileURL 동반)이 이 형태를 놓친다.

## What Changes

- 드롭 지원: 채팅 패널(기록·입력 영역)에 이미지 드롭 대상 추가 — 이미지
  파일 URL 드롭 시 지원 모델이면 첨부 승격, 미지원이면 거부 안내.
  경로가 입력란에 삽입되지 않는다.
- 붙여넣기 판정 강화: 경로 형태의 문자열( "/" 또는 file:// 시작 +
  이미지 확장자 + 파일 존재)만 있는 pasteboard도 이미지 붙여넣기로
  판정한다.
- 게이트·스테이징·ID 부여는 기존 이미지 첨부 경로를 그대로 재사용.

## Capabilities

### New Capabilities

- `chat-conversation`: 이미지 드롭 요구사항 추가

### Modified Capabilities

- `chat-conversation`: 붙여넣기 형식 제한 — 경로 문자열만 있는 이미지
  붙여넣기 판정 추가

## Impact

- `Sources/MenuBarChat/MenuBarChatApp.swift` — 붙여넣기 판정 보강
- `Sources/MenuBarChat/ContentView.swift` — dropDestination 추가
- `openspec/specs/chat-conversation/spec.md` — 요구사항 2건 (아카이브 시
  반영)
