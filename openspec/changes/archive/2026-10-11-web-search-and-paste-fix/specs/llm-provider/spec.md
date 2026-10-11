## MODIFIED Requirements

### Requirement: chat completions 요청
`<baseURL>/chat/completions`로 `Authorization: Bearer <apiKey>`,
`Content-Type: application/json`, 300초 타임아웃으로 POST하며, 본문은
전체 대화를 담은 `{model, stream: true, thinking: {budget: <사고 수준>},
messages: [{role, content}]}` JSON이다. 웹 검색이 켜져 있으면
`tools: [{"type": "web_search", "web_search": {"enable": true,
"search_result": true}}]`를 함께 보낸다.

#### Scenario: 기본 구성
- **WHEN** 저장된 설정이 없으면
- **THEN** 요청은 glm-5.3-flash 모델로 Z.AI 코딩 엔드포인트를 대상으로 하며 web_search 도구를 포함한다

#### Scenario: 웹 검색 끄기
- **WHEN** 설정에서 웹 검색을 끄면
- **THEN** 요청은 web_search 도구 없이 보내진다
