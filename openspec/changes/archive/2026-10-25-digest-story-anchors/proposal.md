# Proposal

## Why

Links 목록이 내비·댓글토론 같은 같은-호스트 앵커에 잠식돼 상한 안에서
뒤쪽 스토리가 잘린다(HN 실측: 절대 앵커 35개 중 스토리가 164개 상대
앵커에 밀림) — 다이제스트 무링크 항목의 주원인.

## What Changes

- filteredAnchors를 외부-호스트 우선으로: 페이지 호스트와 다른 URL의
  앵커만 Links에 남긴다(스토리 본문 링크가 곧 외부 링크). 상한 80 유지.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 웹 페이지 읽기 — 앵커 외부-호스트 필터

## Impact

- `Sources/MenuBarChat/PageFetcher.swift` — filteredAnchors 호스트 비교
- SelfTest — 외부 우선 회귀
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
