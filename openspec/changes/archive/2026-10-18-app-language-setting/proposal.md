# Proposal

## Why

출력 언어가 시스템 기본 언어에서 파생되어 고정된다. 언어를 설정으로
바꾸고 urlHandling·명령 프롬프트가 즉시 따르게 하고 싶다.

## What Changes

- 설정에 "Language" 필드 추가: 프리셋 Picker(Korean/English/Japanese/
  Chinese/Spanish + Custom 직접 입력), 기본값은 시스템 기본 언어.
- `{language}` 플레이스홀더를 전송 시점 치환: urlHandling 지시문과
  명령 프롬프트에서 `{language}` → 설정 언어명. 시드되는 news 프롬프트와
  urlHandling 기본값이 플레이스홀더를 쓰도록 바뀐다.
- 이미 저장된 사용자 텍스트(편집된 urlHandling·명령)는 사용자 것이므로
  그대로 둔다(기존 "사용자 편집 우선" 원칙).
- 언어 설정 변경은 다음 전송부터 즉시 반영된다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `settings`: 설정 필드·영속화 — Language 필드와 기본값들 갱신
- `chat-conversation`: 기본 지시문·커스텀 슬래시 명령 — `{language}`
  치환 명시

## Impact

- `Sources/MenuBarChat/SettingsStore.swift` — appLanguage 필드·기본값·
  시드 프롬프트
- `Sources/MenuBarChat/ChatModel.swift` — 전개 시 치환
- `Sources/MenuBarChat/PromptComposer.swift` — 지시문 치환
- `Sources/MenuBarChat/ContentView.swift` — 설정 Picker
- SelfTest — 치환 회귀
