# Design

## Context

로컬 명령은 "프롬프트를 만드는" 기존 명령 체계와 결이 다르다 — 전개·
전송·스트리밍을 건너뛰고 말풍선만 삽입한다. 가로채 지점을 전개 직후로
잡으면 명령 목록·완성·전송 UX는 그대로 재사용할 수 있다.

## Goals / Non-Goals

**Goals:**

- `/previous-news` 한 글자 입력으로 최근 다이제스트 즉시 재표시

**Non-Goals:**

- 이력 열람 UI(목록·선택), 이전 항목 인덱스 지정(`/previous-news 2`),
  영구 아카이브

## Decisions

### D1: 가로채 — send() 전개 분기 안

`matchedCommand`가 "previous-news"면 전개 대신: `NewsHistory.load()`
최신 항목 text로 `Message(role: .assistant, text:)` 삽입 +
`finalizeLastAssistantMarkdown()` 호출(즉시 렌더), `viaCommand`/
`commandName`은 사용자 쪽에 기록하지 않는다 — 재저장 훅의 조건
(commandName == "news")과 무관하게 두는 게 본질(스텁도 짧은 원문
그대로). 비었으면 안내 문구 말풍성. 반환 후 스트림 진입 없음.

### D2: builtinCommands 등록 — 프롬프트 빈 문자열

`SlashCommand(name: "previous-news", prompt: "")` 등록으로 드롭다운·
Tab 완성이 자동 동작. 전개 경로는 가로채가 먼저 소진하므로 프롬프트는
쓰이지 않는다(빈 값 = 미사용 표시).

### D3: 재저장 방지

saveNewsHistoryIfNeeded는 `commandName == "news"` 조건이라
previous-news 실행은 자동으로 재저장되지 않는다(D1에서 commandName을
기록하지 않으니 이중 안전).

## Risks / Trade-offs

- [24h 창 밖 소실] 링 정책에 따름 — 안내 문구로 "없음"을 명확히.

## Migration Plan

1. builtinCommands 등록 → 2. send() 가로채·삽입·안내 →
build/selftest/all-build → 수동(이력 있음/비었음 두 케이스)
