# Proposal

## Why

`/news` 실행 시 페이지마다 og:image 미리보기 말풍선이 4개 나열되어
소음이고, 페이지별 ID는 라벨("More, ID1"이 첫 페이지만 가리키는 듯한
모호함)·번호 낭비를 만든다. 명령 실행은 하나의 작업 단위이므로 **첨부
1개(묶음 ID)**로 표시하는 것이 개념에 맞다.

## What Changes

- 명령으로 전개된 메시지의 페이지 묶음에 통합 카운터로 **1개의 ID**를
  부여한다(개별 페이지 ID 없음). 미리보기는 썸네일 없이 `ID · N sources`
  머리 + 도메인 목록의 단일 카드(실패 줄은 간결한 오류 표기)다.
- 묶음 ID는 참조 표시(카드·추론 접힘 라벨·히스토리 스텁 1줄)로 쓰이며,
  **언급 재포함은 제공하지 않는다** — 심화는 관심 사이트 URL을 직접
  다시 보내는 기존 단일 URL 경로 사용.
- 일반 메시지의 기존 동작(첫 URL 1개 fetch·페이지별 ID·og:image
  미리보기·언급 재포함)은 무변경. fetch(상한 10개·2창)·발췌 예산·표시
  본문도 무변경.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 웹 페이지 읽기 — 명령 전개 메시지의 묶음 ID·단일
  카드, 첨부 ID 언급 재포함 — 묶음 제외

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — 묶음 ID 부여(메시지 수준 저장)
- `Sources/MenuBarChat/PromptComposer.swift` — 명령 메시지 스텁 1줄·묶음
  언급 무시
- `Sources/MenuBarChat/ContentView.swift` — 단일 목록 카드
- `openspec/specs/chat-conversation/spec.md` — 요구사항 2건 (아카이브 시
  반영)
