# Proposal

## Why

"답변 생성 중…" 대기의 대부분이 사고 수준 high의 추론 단계다(실사용
관찰 — 요약형 요청에서 수십 초). 요약·종합은 심층 추론 과제가 아니므로
high의 이득이 비용(대기)보다 작다.

## What Changes

- 기본 지시문이 적용되는 요청 — URL 하나뿐인 메시지, 긴 붙여넣기(10줄
  초과), 뉴스 다이제스트 명령 — 은 요청 페이로드의 사고 수준을
  `medium`으로 오버라이드한다. 그 외 요청(일반 대화, URL+텍스트 혼합 등
  사용자의 명시적 질문)은 설정의 사고 수준을 그대로 따른다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 기본 지시문 — 요약형 요청의 사고 수준 medium

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — stream() 페이로드 오버라이드
- SelfTest — 조건 판정 순수 함수가 가능하면 고정
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
