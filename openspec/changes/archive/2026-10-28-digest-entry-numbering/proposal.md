# Proposal

## Why

다이제스트 항목에 번호가 실행마다 들쭉날쭉하다 — 형식 지시에 번호
매기기가 없어 모델이 자율로 정한다(실사용 관찰).

## What Changes

- 형식 템플릿에 번호 명시: STEM `N. **[Title](URL)**`(불확실 시
  `N. **Title**`), 일반 `N. [Title](URL)]`(불확실 시 `N. Title`) — 양쪽
  섹션 모든 항목에 항상 번호.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `settings`: 영속화 — 내장 news 프롬프트 형식 문구

## Impact

- `Sources/MenuBarChat/SettingsStore.swift` — 형식 문장
- SelfTest — 기대값 갱신
- `openspec/specs/settings/spec.md` — 요구사항 1건 (아카이브 시 반영)
