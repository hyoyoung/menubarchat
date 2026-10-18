# Proposal

## Why

JS 의존 사이트(네이버뉴스·CNN 등)는 정적 DOM 텍스트가 내비게이션·크롬
조각이라도 글자 수 기준(≥200자)을 통과해, 렌더링 추출 경로로 넘어가지
못하고 발췌 창에 크롬만 실린다(실측: 네이버 제거 후 93k 자 중 시작이
내비 숩, CNN 4.8MB React 앱의 정적 텍스트는 광고 설문 크롬). 결과적으로
/news 다이제스트에서 해당 사이트가 누락된다.

## What Changes

- "충분한 본문인가" 판정을 글자 수에서 **품질 기준**으로 교체: 공백 접기
  + 기호·공백만 남은 조각 제거 후 실내용 기준으로 판정한다. 내비 숩은
  미달로 판정되어 기존 WebKit 렌더링 추출(타임아웃 경쟁)으로 폴백하고,
  렌더링 결과도 같은 품질 기준을 통과해야 채택된다.
- 정적 텍스트 풍부 사이트(HN·BBC)는 기존 빠른 경로 유지(회귀 없음).
- 발췌·미리보기에 딸리는 공백 노이즈도 접힌다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 웹 페이지 읽기 — 본문 품질 판정·렌더링 폴백 명시

## Impact

- `Sources/MenuBarChat/PageFetcher.swift` — 품질 판정 헬퍼 + 폴백 흐름
- SelfTest — 품질 판정 회귀(내비 숩 미달·실내용 통과)
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
