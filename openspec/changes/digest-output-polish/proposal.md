# Proposal

## Why

`/news` 답변에 두 잡음이 섞인다 — ① 모델이 "skip typical news"를
"무엇을 제외했는지 설명"으로 이행해 ※ 안내문을 다는다(ID 안내문 사태와
같은 패턴), ② 다이제스트와 메모 사이의 연속 빈 줄이
inlineOnlyPreservingWhitespace 렌더러에서 그대로 커다란 공백으로
표시된다.

## What Changes

- 내장 news 프롬프트: 비STEM 섹션을 "the top 15 important or unusual
  events outside STEM"로 상한 15개 지정(STEM과 대칭 캡), 제외 지시는
  "skip typical news without mentioning exclusions." 로 수정해 제외를
  보고하지 않고 묵묵히 수행.
- 마크다운 전처리: 세 개 이상 연속 줄바꿈을 빈 줄 하나로 접는다
  (markdown() 파싱 전 — 표시 정규화).

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `settings`: 영속화 — 내장 news 프롬프트 요약 문구 갱신
- `chat-conversation`: 인라인 마크다운 표시 — 과도한 줄바꿈 접기

## Impact

- `Sources/MenuBarChat/SettingsStore.swift` — builtinCommands 프롬프트
- `Sources/MenuBarChat/ContentView.swift` — markdown() 전처리 1줄
- SelfTest — 기대값 갱신·줄바꿈 접기 회귀
