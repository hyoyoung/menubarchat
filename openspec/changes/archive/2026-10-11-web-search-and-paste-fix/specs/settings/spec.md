## MODIFIED Requirements

### Requirement: 설정 필드
패널 내 설정 섹션에 비밀 API 키 필드, base URL 필드, 모델 선택(프리셋
`glm-5.3-flash`/`glm-5.3`/`glm-4.6` + `Custom…` 직접 입력), 사고(thinking)
수준 선택(`low`/`medium`/`high`/`max`), 웹 검색 토글을 제공한다.

### Requirement: 영속화
편집 즉시 `apiKey`, `baseURL`, `model`, `thinkingBudget`, `webSearch`를
UserDefaults에 저장하고 실행 시 불러온다. 저장된 값이 없을 때 기본값:
base URL `https://api.z.ai/api/coding/paas/v4`, 모델 `glm-5.3-flash`, 사고
수준 `high`, 웹 검색 켬, API 키는 환경변수 `ZAI_API_KEY`(그 다음
`Z_AI_API_KEY`)에서 읽는다.
