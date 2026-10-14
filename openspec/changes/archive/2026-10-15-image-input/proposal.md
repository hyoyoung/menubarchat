# Proposal

## Why

기본 모델 glm-5.3-flash는 네이티브 멀티모달(이미지·비디오·파일)이지만
앱은 이미지 붙여넣기를 전면 거부한다. 스크린샷을 물어보는 간단한 워크플로가
불가능하다.

## What Changes

- 붙여넣기 가로채기에서 이미지를 수용한다 — 단, **현재 모델이 이미지
  입력을 지원할 때만**(모델명에 "flash" 포함; 검증된 것은 이 계열뿐).
  미지원 모델이면 기존 거부 안내를 유지한다.
- 텍스트 없는 이미지 붙여넣기는 즉시 첨부 항목(썸네일 칩, 삭제 가능)으로
  승격한다(기존 stagedPaste 패턴, 단일 슬롯). 텍스트와 함께 있으면
  텍스트만 취하는 기존 규칙 유지.
- 전송 시 긴 변을 1568px로 제한해 JPEG Base64 Data URL로 만들고
  `image_url` content 파트로 실린다(공식 문서 형식). 첨부 ID 시스템
  확장: `ID<n>i` 부여, 마지막 메시지인 요청에만 실리고 이후 요청부터는
  `[Image ID<n>i]` 스텁, 언급 시 재포함.
- 사용자 말풍선에 이미지 썸네일을 표시한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 붙여넣기 형식 제한 — 지원 모델에서 이미지 수용;
  이미지 첨부 요구사항 추가(ID<n>i·스텁·재포함·리사이즈)
- `llm-provider`: chat completions 요청 — 마지막 메시지에 이미지가 있으면
  content를 텍스트+`image_url` 파트 배열로 전송

## Impact

- `Sources/MenuBarChat/PageFetcher.swift` 외 신규 헬퍼 `ImageEncoder.swift`
  (리사이즈·Data URL, 순수 함수 + SelfTest)
- `ChatModel`, `MenuBarChatApp`(가로채기), `ContentView`(칩·썸네일),
  `PromptComposer`(파트 배열·ID<n>i), `LLMClient`(혼합 content)
- 스펙 2건 (아카이브 시 반영)
