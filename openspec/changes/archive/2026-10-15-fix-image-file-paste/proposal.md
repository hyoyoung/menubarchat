# Proposal

## Why

파일로 캡처한 스크린샷을 복사해 붙여넣으면 pasteboard가 이미지 데이터와
함께 파일 경로를 문자열로 동반한다. 현재 가로채기가 텍스트 유무를
먼저 검사해 "텍스트 있음"으로 판정, 경로가 그대로 입력란에 붙어 이미지
입력이 동작하지 않는다(미지원 모델에서도 경로가 붙는다).

## What Changes

- 가로채기 판정 순서 변경: pasteboard에 이미지가 있고 문자열이 비었거나
  파일 URL에서 온 경로면 이미지 붙여넣기로 확정한다(지원 모델 → 첨부
  승격, 미지원 → 거부 안내).
- 독립 텍스트가 있는 진짜 텍스트+이미지 혼합(웹 선택 복사 등)은 기존
  규칙(텍스트 우선)을 유지한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 붙여넣기 형식 제한 — 파일 경로 동반 이미지는
  이미지로 판정한다는 구분 명시

## Impact

- `Sources/MenuBarChat/MenuBarChatApp.swift` — interceptPaste 판정 순서
  (수 줄)
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
