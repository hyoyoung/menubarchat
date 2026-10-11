# LLM 공급자 스펙

## 목적

Z.AI GLM API(OpenAI 호환)와의 HTTP 계약.

## Requirements

### Requirement: chat completions 요청
`<baseURL>/chat/completions`로 `Authorization: Bearer <apiKey>`,
`Content-Type: application/json`, 300초 타임아웃으로 POST하며, 본문은
전체 대화를 담은 `{model, stream: true, thinking: {budget: "low"},
messages: [{role, content}]}` JSON이다.

#### Scenario: 기본 구성
- **WHEN** 저장된 설정이 없으면
- **THEN** 요청은 glm-5.3 모델로 Z.AI 코딩 엔드포인트를 대상으로 한다

### Requirement: 사고(thinking) 예산
`{"budget": "low"}`로 사고를 요청하며, 상시 사고 모델(glm-5.x)이 1210
오류로 거부하는 `thinking.type`은 절대 보내지 않는다.

### Requirement: SSE 파싱
응답 스트림에서 `data:` 라인을 파싱하고 `[DONE]`에서 멈춘다. 델타에
`content`도 `reasoning_content`도 없는 이벤트는 무시하되, `usage` 객체가
있는 이벤트는 입력/출력 토큰 수로 해석해 현재 어시스턴트 메시지에
기록한다.

#### Scenario: 마지막 청크의 usage
- **WHEN** 마지막 청크에 `usage`(`prompt_tokens`, `completion_tokens`)가 포함되면
- **THEN** 해당 값이 답변 메시지의 토큰 소비량으로 기록된다
