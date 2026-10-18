# Proposal

## Why

반복 제거 지시("do not repeat stories already covered")가 무조건 제외라
중요 기사의 후속 전개까지 잘린다. 섹션별로 반대 기본값을 둔다 — STEM은
우선 콘텐츠라 중복을 사소할 때만 제외(기본 유지), 일반 뉴스는 신선함
우선으로 중복을 중요 전개일 때만 유지(기본 제외).

## What Changes

- 내장 news 프롬프트의 이전 다이제스트 지시를
  "keep already-covered STEM stories unless minor, and skip
  already-covered general news unless it is a major development"로
  교체 — 중요성 판단은 모델에 위임, 대칭 구조로 섹션별 기본값 전달.
  나머지 문장 무변경.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `settings`: 영속화 — 내장 news 프롬프트 요약 문구 갱신

## Impact

- `Sources/MenuBarChat/SettingsStore.swift` — builtinCommands 한 절
- SelfTest — 기대값 갱신
- `openspec/specs/settings/spec.md` — 요구사항 1건 (아카이브 시 반영)
