# Spec Delta

## MODIFIED Requirements

### Requirement: chat completions 요청
`<baseURL>/chat/completions`로 `Authorization: Bearer <apiKey>`,
`Content-Type: application/json`, 300초 타임아웃으로 POST하며, 본문은
전체 대화를 담은 `{model, stream: true, thinking: {budget: <사고 수준>},
messages: [{role, content}]}` JSON이다. 마지막 사용자 메시지에 이미지
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
