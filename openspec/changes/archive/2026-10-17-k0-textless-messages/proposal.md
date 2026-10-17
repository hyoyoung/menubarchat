# Proposal

## Why

K=1 윈도우의 잔여 비용은 "요청당 직전 답변 1개"인데, URL 요약·이미지
질의처럼 새 작업 성격의 전송에서는 직전 답변마저 불필요하다. 의도
분류(키워드·LLM)는 오분류로 후속 질문을 끊는 위험이 커서, 구조적으로
안전한 판정만 쓴다.

## What Changes

- 보내는 마지막 사용자 메시지가 **텍스트 없이** URL 또는 이미지만 담고
  있으면 직전 답변도 제외한다(K=0). 한 글자라도 텍스트가 있으면 기존
  K=1을 유지한다.
- 근거: 참조 신호는 자유 텍스트뿐 — 텍스트가 없으면 메시지가 이전
  대화를 참조할 방법이 없어 오분류가 원천 불가능하다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `llm-provider`: chat completions 요청 — 텍스트 없는 마지막 메시지는
  직전 답변도 제외

## Impact

- `Sources/MenuBarChat/PromptComposer.swift` — transcript() 규칙 확장
- SelfTest 2건 추가
- `openspec/specs/llm-provider/spec.md` — 요구사항 1건 (아카이브 시 반영)
