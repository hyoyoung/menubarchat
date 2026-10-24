# Proposal

## Why

굵기가 링크 매칭 성공 여부의 신호인데, STEM 소스는 Links 제목이 영어
원문이라 한국어 제목과 짝짓기가 애매해 기울임으로 몰리고 네이버는
한국어라 굵게 몰린다 — 섹션별로 굵기가 갈리는 착시로 보임(실사용
관찰).

## What Changes

- 항목 서식 지시를 통일: 제목은 항상 굵게, 본문은 항상 보통, URL를
  알면 제목에 링크로 얹고 불확실하면 링크 없이 — 기울임 규칙 삭제.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `settings`: 영속화 — 내장 news 프롬프트 서식 문구 갱신

## Impact

- `Sources/MenuBarChat/SettingsStore.swift` — 프롬프트 한 문장
- SelfTest — 기대값 갱신
- `openspec/specs/settings/spec.md` — 요구사항 1건 (아카이브 시 반영)
