# Proposal

## Why

다이제스트 밀도가 섹션별로 반대로 어긋난다 — STEM은 "주요 건만" 심화라
대부분 한 줄로 끝나고, 일반은 "한 줄"인데 모델이 부연 2-3줄을 자의로
추가한다(실사용 관찰).

## What Changes

- STEM: 모든 항목이 제목 아래 2-3줄(그 줄이 요약·심화 전부), 화제·중요한
  스토리는 최대 5줄.
- 일반: 항목당 정확히 한 줄(제목+요약), 부가 줄 금지.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `settings`: 영속화 — 내장 news 프롬프트 밀도 문구

## Impact

- `Sources/MenuBarChat/SettingsStore.swift` — 프롬프트 두 문장
- SelfTest — 기대값 갱신
- `openspec/specs/settings/spec.md` — 요구사항 1건 (아카이브 시 반영)
