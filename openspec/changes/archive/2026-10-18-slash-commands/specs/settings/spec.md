# Spec Delta

## MODIFIED Requirements

### Requirement: 설정 필드
패널 내 설정 섹션에 "API key" 비밀 필드, "Base URL" 필드, 모델 선택(프리셋
`glm-5.3-flash`/`glm-5.3`/`glm-4.6` + `Custom…` 직접 입력), 사고 수준
선택(`low`/`medium`/`high`/`max`), 웹 검색 토글, "URL handling" 지시문
필드, 커스텀 명령 목록 편집기(이름 + 프롬프트 쌍의 추가·수정·삭제)를
제공한다.

#### Scenario: 프리셋 없는 모델 직접 입력
- **WHEN** 모델 선택에서 "Custom…"을 고르고 모델 이름을 입력하면
- **THEN** 입력한 이름이 요청 모델로 저장되어 사용된다

#### Scenario: 명령 추가
- **WHEN** 설정에서 이름 `news`와 프롬프트를 입력해 명령을 추가하면
- **THEN** 입력창에서 `/news`로 해당 프롬프트를 전개할 수 있다

### Requirement: 영속화
편집 즉시 `apiKey`, `baseURL`, `model`, `thinkingBudget`, `webSearch`,
`urlHandling`, 커스텀 명령 목록을 UserDefaults에 저장하고 실행 시
불러온다. 기본값: base URL `https://api.z.ai/api/coding/paas/v4`, 모델
`glm-5.3-flash`, 사고 수준 `high`, 웹 검색 끔, URL 지시문 `summarize it in <시스템 기본 언어>`, API
키는 환경변수 `ZAI_API_KEY`(그 다음 `Z_AI_API_KEY`). 명령 목록의 기본값은
`news` 다이제스트 명령 1개(4개 뉴스 사이트 URL 포함 종합 요약
프롬프트)이며, 저장된 목록이 있으면 그것을 쓰고 사용자가 지운 명령은
다시 생기지 않는다.

#### Scenario: 재시작 후 설정 유지
- **WHEN** 설정 필드를 편집한 뒤 앱을 재시작하면
- **THEN** 편집한 값이 유지되어 그대로 적용된다

#### Scenario: 기본 명령 제공
- **WHEN** 처음 실행하면
- **THEN** 뉴스 종합 요약 프롬프트를 가진 `news` 명령이 등록되어 있다
