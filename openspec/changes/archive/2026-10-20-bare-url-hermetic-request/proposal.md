# Proposal

## Why

URL-only 메시지(K=0) 전송에서 어시스턴트 답변은 이미 제외하면서 사용자
히스스토리(명령 스텁·과거 URL·페이지 스텁)는 실어 보낸다 — "맥락 불필요"
선언을 절반만 적용한 상태. 잔여 노이즈·토큰 비용이 있고 정보량은 0에
가깝다.

## What Changes

- URL 하나뿐인 메시지의 요청을 밀폐(hermetic)로: 그 메시지(본문 + 기본
  지시문)만 전송하고 과거 사용자 메시지·스텁·첨부 참조는 포함하지
  않는다. URL과 텍스트가 섞인 메시지는 기존대로 전체 맥락을 유지한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 기본 지시문 — URL-only 요청의 밀폐 전송 명시

## Impact

- `Sources/MenuBarChat/PromptComposer.swift` — windowing K=0 분기
- SelfTest — 밀폐 회귀
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
