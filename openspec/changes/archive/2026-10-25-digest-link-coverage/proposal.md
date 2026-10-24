# Proposal

## Why

다이제스트 링크 커버리지가 낮다(최근 실행 30항목 중 9개) — 앵커 상한
40개가 링크 많은 소스(HN 등)의 뒤쪽 스토리를 밀어내 목록에서 유실시키고,
"if unsure, omit"이 패러프레이즈 제목(한국어)을 생략으로 귀결시킨다
(실사용 관찰 — "The Real Kevin Bacon" 무링크).

## What Changes

- 페이지당 앵커 상한 40 → 80.
- 프롬프트에 매치 완화 문장: "Attach the most plausible anchor URL even
  when the title is paraphrased; omit the link only when no plausible
  candidate exists." (오탐 감수, 커버리지 우선)

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 웹 페이지 읽기 — 앵커 상한 80
- `settings`: 영속화 — 내장 news 프롬프트 매치 완화 문구

## Impact

- `Sources/MenuBarChat/PageFetcher.swift` — 상한 상수
- `Sources/MenuBarChat/SettingsStore.swift` — 프롬프트 문장
- SelfTest — 상한 기대치 갱신
