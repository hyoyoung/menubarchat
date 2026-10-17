# Proposal

## Why

과거 턴 첨부 스텁의 교육 문구(`— mention "ID<n>" to re-include`)가
모델에게 언급 재포함 인터페이스를 "알려주도록" 가르쳐, URL 요약을
거듭한 대화에서 "본문이 없으니 ID를 언급해 달라"는 안내문이 답변에
반복해서 등장한다. 단일 사용자는 이미 인터페이스를 알며, 재포함은
앱의 정규식이 기계적으로 수행하므로 모델이 몰라도 동작한다.

## What Changes

- 과거 턴 스텁에서 교육 문구 접미사를 제거한다:
  `[Page ID<n> (<도메인>)]`, `[Text ID<n>p (<첫 줄>)]`,
  `[Image ID<n>i]` — 참조 표시(종류·ID·식별자)는 유지된다.
- 마지막 메시지의 전문·재포함 형식, 언급 감지·재포함 동작은 무변경.
- 이미지 스텁은 스펙이 이미 무접미사였고 코드만 정렬된다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 웹 페이지 읽기·긴 붙여넣기 접기의 스텁 형식

## Impact

- `Sources/MenuBarChat/PromptComposer.swift` — 스텁 문자열 3곳
- SelfTest — 스텁 기대값 3건 갱신
- `openspec/specs/chat-conversation/spec.md` — 요구사항 2건 (아카이브 시
  반영)
