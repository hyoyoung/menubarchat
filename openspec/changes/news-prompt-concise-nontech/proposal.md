# Proposal

## Why

심화 줄 지시("2-3 more lines")가 tech/non-tech 구분 없이 적용되어 비IT
섹션까지 장황해진다. 심화는 IT 뉴스에만, 비IT는 한 줄 간결화가 의도.

## What Changes

- 시드 `news` 프롬프트 수정: 심화 줄을 "major or trending IT stories"로
  한정하고, 비IT 섹션은 "each as a single concise line"으로 지시.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `settings`: 영속화 — 시드 프롬프트 설명 갱신

## Impact

- `Sources/MenuBarChat/SettingsStore.swift` — defaultCommands 프롬프트
- SelfTest — 기대값 갱신
- `openspec/specs/settings/spec.md` — 요구사항 1건 (아카이브 시 반영)
