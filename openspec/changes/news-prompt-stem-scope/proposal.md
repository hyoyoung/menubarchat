# Proposal

## Why

다이제스트 범위를 컴퓨터·IT에서 컴퓨터·과학·수학·IT로 넓히고 문구를
깔끔하게 다듬는다. 분야 표현이 길어지므로 심화 줄·비섹션 문구도 범위에
맞춰 재구성한다.

## What Changes

- 시드 `news` 프롬프트: "top 15 computer, science, mathematics, and
  information technology news stories"로 범위화. 심화 줄은 "For major or
  trending stories"(분야 한정 부사 제거 — 문맥이 이미 범위 안),
  비주요 섹션은 "events outside these fields"로 재구성.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `settings`: 영속화 — 시드 프롬프트 설명 갱신

## Impact

- `Sources/MenuBarChat/SettingsStore.swift` — defaultCommands 프롬프트
- SelfTest — 기대값 갱신
- `openspec/specs/settings/spec.md` — 요구사항 1건 (아카이브 시 반영)
