# Proposal

## Why

서식 지시가 STEM 문장 바로 뒤에 붙어 "STEM 목록의 서식"으로 읽히고, 일반
뉴스 문장의 "one line each"가 서식 없는 한 줄로 해석된다 — 섹션별로 굵기가
갈라지는 잔존 불일치(실사용 관찰).

## What Changes

- 서식 지시를 양쪽 섹션에 명시적으로 고정: "Format every entry in both
  sections as: …" + 일반 뉴스 문장에 "formatted the same way" 각인.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `settings`: 영속화 — 내장 news 프롬프트 서식 문구 갱신

## Impact

- `Sources/MenuBarChat/SettingsStore.swift` — 프롬프트 두 문장
- SelfTest — 기대값 갱신
- `openspec/specs/settings/spec.md` — 요구사항 1건 (아카이브 시 반영)
