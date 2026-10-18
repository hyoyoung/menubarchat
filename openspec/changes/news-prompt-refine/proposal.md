# Proposal

## Why

`/news` 프롬프트의 "tech news"가 모호하다 — 컴퓨터·IT 뉴스로 한정하고
싶다. 또 주요/화제 뉴스는 한 줄 요약으로 부족하니 2~3줄 심화가 필요하다.

## What Changes

- 시드된 `news` 프롬프트 수정: tech를 "computer/IT (information
  technology)"로 명시, 주요·화제 뉴스는 요약에 2~3줄을 더 붙이도록 지시.
- 저장된 목록이 없어 시드가 그대로 반영된다(현재 상태 해당).

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `settings`: 영속화 — 시드 프롬프트 설명 갱신

## Impact

- `Sources/MenuBarChat/SettingsStore.swift` — defaultCommands 프롬프트
- SelfTest — 시드 프롬프트 기대값 갱신
- `openspec/specs/settings/spec.md` — 요구사항 1건 (아카이브 시 반영)
