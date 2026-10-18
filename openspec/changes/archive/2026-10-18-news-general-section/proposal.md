# Proposal

## Why

비STEM 섹션 문장이 "events outside STEM" — 부정형 정의라 섹션 정체성이
"나머지"가 되고, 모델이 사고·범죄 같은 전형적 기사로 채우는 심리적 원인이
된다. 표준 언론 용어인 "general news"로 긍정형 카테고리를 부여한다.

## What Changes

- 내장 news 프롬프트의 비STEM 섹션 문장을
  "Follow with the top 15 general news stories, one line each — skip
  typical news without mentioning exclusions."로 교체. 나머지 문장·
  구조(STEM 15개·심화·{previous}·{language})는 무변경.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `settings`: 영속화 — 내장 news 프롬프트 요약 문구 갱신

## Impact

- `Sources/MenuBarChat/SettingsStore.swift` — builtinCommands 한 문장
- SelfTest — 기대값 갱신
- `openspec/specs/settings/spec.md` — 요구사항 1건 (아카이브 시 반영)
