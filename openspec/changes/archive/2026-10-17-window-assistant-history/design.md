# Design

## Context

스트리밍 요청의 messages는 현재 전체 대화를 담는다. 절감 레버는 과거
어시스턴트 답변 전문(지배적). 사용자 선택: 하드 절단, 직전 답변 1개만
유지(K=1), 스텁 없음.

## Goals / Non-Goals

**Goals:**

- 긴 대화의 요청 토큰 대폭 절감(~80%, 20턴 기준)
- 직전 후속 질문("그거 더 자세히")의 맥락 보존

**Non-Goals:**

- 스텁·색인, 롤링 요약, K 설정화, 표시 변경

## Decisions

### D1: K=1, 스텁 없음 — 사용자 확정 선택

직전 어시스턴트 답변 1개만 전송. 2턴 이전 답변 인용은 모델이 알 수
없다는 손실을 명시적으로 수용(최대 절감과의 교환).

### D2: 조립은 PromptComposer 순수 함수로 — SelfTest로 고정

`PromptComposer.transcript(messages:urlHandling:)`가 필터 규칙(사용자
전부 + 마지막 어시스턴트 1개)과 기존 apiContent·이미지 파트 조립을
한 번에 수행하고 ChatModel.stream()은 결과만 LLMClient에 넘긴다.
테스트: 답변 3개 중 마지막 1개만 포함, 사용자 메시지 전부 포함,
직전 답변 앞뒤 순서 유지.

### D3: 오류 말풍선도 동일 규칙

마지막 어시스턴트 메시지가 오류 안내("Error: …")여도 규칙 그대로
포함한다(예외 분기 없음 — 재시도 맥락으로 무해).

## Risks / Trade-offs

- [직전보다 오래된 답변 인용 붕괴] — 수용된 손실. 필요해지면 스텁
  추가(별도 변경)로 완화 가능.
- [사용자 메시지 연속] — 답변이 빠져 user 연속이 생겨도 API는 허용.

## Migration Plan

1. transcript() 함수 + SelfTest → 2. stream() 교체 → build/selftest →
   all-build → 수동 확인(긴 대화 전송·후속 질문·첨부 재포함)
