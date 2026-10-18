# Proposal

## Why

내장 `news` 프롬프트에 군더더기가 있다 — "the content from",
"information technology" 풀拼写, "more"/"separate" 등 의미 없는
단어들. 분야 나열은 표준 약어 STEM으로 치환하고 일상 사고 제외는
"skip typical news"로 일반화한다(구체적 나열보다 정확도는 낮지만
"important or unusual"과 대구를 이뤄 의도 전달, 문제 시 다음 반복에서
보강).

## What Changes

- 내장 프롬프트를 간결판으로 교체(~90단어 → ~52단어), 의미 구조 5가지
  보존: STEM 범위 / 심화는 top-15 STEM 한정("for major or trending
  ones") / 비STEM 한 줄 / 일상 사고 제외 / `{language}` 출력.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `settings`: 영속화 — 내장 news 프롬프트 요약 문구 갱신

## Impact

- `Sources/MenuBarChat/SettingsStore.swift` — builtinCommands 프롬프트
- SelfTest — 기대값 갱신
- `openspec/specs/settings/spec.md` — 요구사항 1건 (아카이브 시 반영)
