# LLM 공급자 스펙

## Purpose

Z.AI GLM API(OpenAI 호환)와의 HTTP 계약.

## Requirements

### Requirement: chat completions 요청
`<baseURL>/chat/completions`로 `Authorization: Bearer <apiKey>`,
`Content-Type: application/json`, 300초 타임아웃으로 POST하며, 본문은
대화를 담은 `{model, stream: true, thinking: {budget: <사고 수준>},
messages: [{role, content}]}` JSON이다. messages는 모든 사용자 메시지와
**직전 어시스턴트 답변 1개만** 포함한다 — 더 오래된 어시스턴트 답변은
전송에서 제외되며 스텁으로도 남기지 않는다. 마지막 사용자 메시지에 이미지
첨부가 있으면 그 메시지의 content는
`[{type: "text"}, {type: "image_url", image_url: {url: <Base64 Data URL>}}]`
파트 배열이고, 나머지 메시지는 문자열 content를 유지한다. 웹 검색이
켜져 있으면 `tools: [{"type": "web_search", "web_search": {"enable":
true, "search_result": true}}]`를 함께 보낸다. 기본 구성(저장된 설정
없음)은 glm-5.3-flash 모델로 Z.AI 코딩 엔드포인트를 대상으로 한다.

#### Scenario: 기본 구성 요청
- **WHEN** 저장된 설정 없이 요청을 보내면
- **THEN** glm-5.3-flash 모델로 Z.AI 코딩 엔드포인트 `/chat/completions`에 스트림 요청이 전송된다

#### Scenario: 이미지 파트 전송
- **WHEN** 마지막 메시지에 이미지 첨부가 있으면
- **THEN** 그 메시지의 content는 텍스트 파트와 이미지 파트의 배열로
  전송된다

#### Scenario: 오래된 답변 제외
- **WHEN** 어시스턴트 답변이 2개 이상 쌓인 대화에서 요청을 보내면
- **THEN** 직전 답변 1개만 messages에 포함되고 나머지 답변은 전송되지
  않는다

### Requirement: 사고(thinking) 예산
설정의 사고 수준(`low`/`medium`/`high`/`max`)을 `{"budget": <수준>}`으로
요청하며, 상시 사고 모델(glm-5.x)이 1210 오류로 거부하는 `thinking.type`은
절대 보내지 않는다.

#### Scenario: 사고 수준 전달
- **WHEN** 설정의 사고 수준이 `high`이면
- **THEN** 본문에 `thinking: {"budget": "high"}`가 담기고 `thinking.type`은 담기지 않는다

### Requirement: SSE 파싱
응답 스트림에서 `data:` 라인을 파싱하고 `[DONE]`에서 멈춘다. 델타에
`content`도 `reasoning_content`도 없는 이벤트는 무시하되, `usage` 객체가
있으면 입력/출력 토큰 수로 해석해 답변 메시지에 기록한다.

#### Scenario: 콘텐츠 없는 이벤트
- **WHEN** 델타에 `content`도 `reasoning_content`도 없는 `data:` 라인이 도착하면
- **THEN** 이벤트는 무시되고 `usage`가 있으면 토큰 수로 해석해 기록한다
