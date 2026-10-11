## ADDED Requirements

### Requirement: URL 단독 입력 처리
사용자 메시지가 URL 하나뿐이면 그 메시지가 마지막 메시지인 요청의
`content` 끝에 `[Instruction: <지시문>]`을 덧붙인다. 지시문 기본값은
`summarize it`이며 설정에서 편집한다. 비어 있으면 덧붙이지 않는다.
말풍선 표시는 URL 원문 그대로다.

#### Scenario: URL만 입력
- **WHEN** 사용자가 URL만 붙여넣어 보내면
- **THEN** 요청에 기본 지시문(summarize it)이 포함되어 모델이 요약으로 답한다

#### Scenario: 지시문 변경
- **WHEN** 설정에서 지시문을 "translate to Korean"으로 바꾸고 URL만 보내면
- **THEN** 모델이 번역으로 답한다

## MODIFIED Requirements

### Requirement: 설정 필드
패널 내 설정 섹션에 비밀 API 키 필드, base URL 필드, 모델 선택(프리셋
`glm-5.3-flash`/`glm-5.3`/`glm-4.6` + `Custom…` 직접 입력), 사고(thinking)
수준 선택(`low`/`medium`/`high`/`max`), 웹 검색 토글, "http/https default
handling" 지시문 필드를 제공한다.

### Requirement: 영속화
편집 즉시 `apiKey`, `baseURL`, `model`, `thinkingBudget`, `webSearch`,
`urlHandling`을 UserDefaults에 저장하고 실행 시 불러온다. 저장된 값이
없을 때 기본값: base URL `https://api.z.ai/api/coding/paas/v4`, 모델
`glm-5.3-flash`, 사고 수준 `high`, 웹 검색 끔, URL 지시문 `summarize it`,
API 키는 환경변수 `ZAI_API_KEY`(그 다음 `Z_AI_API_KEY`)에서 읽는다.
