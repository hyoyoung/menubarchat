# Proposal

## Why

사용자 확정 규칙: 굵기는 STEM 섹션의 신호다 — STEM 제목만 굵게, 일반
뉴스 제목은 보통(링크는 양쪽 유지).

## What Changes

- 항목 서식 지시를 섹션별로 분리: STEM `**[Title](URL)**`(URL 모르면
  `**Title**`), 일반은 같은 형식이되 제목 보통(`[Title](URL)`·URL 모르면
  `Title`). "formatted the same way except …"로 일반 섹션에 서식이
  명시적으로 도달한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `settings`: 영속화 — 내장 news 프롬프트 서식 문구 갱신

## Impact

- `Sources/MenuBarChat/SettingsStore.swift` — 프롬프트 서식 두 문장
- SelfTest — 기대값 갱신
- `openspec/specs/settings/spec.md` — 요구사항 1건 (아카이브 시 반영)
