# Spec Delta

## MODIFIED Requirements

### Requirement: 영속화
편집 즉시 `apiKey`, `baseURL`, `model`, `thinkingBudget`, `webSearch`,
`urlHandling`, `appLanguage`, 커스텀 명령 목록을 UserDefaults에 저장하고
실행 시 불러온다. 기본값: base URL `https://api.z.ai/api/coding/paas/v4`,
모델 `glm-5.3-flash`, 사고 수준 `high`, 웹 검색 끔, URL 지시문
`summarize it in {language}`, 언어는 시스템 기본 언어, API 키는
환경변수 `ZAI_API_KEY`(그 다음 `Z_AI_API_KEY`). 명령 목록의 기본값은
`news` 다이제스트 명령 1개(영어 템플릿: 4개 뉴스 사이트 URL 종합,
컴퓨터·과학·수학·IT 뉴스 상위 15개 + 주요·화제 뉴스의 2~3줄 심화 +
이 분야 밖의 주요·이색 사항 한 줄 간결 목록(일상 사고 — 총격·부상·
교통사고 등 흔한 사고·사건은 제외), 출력 언어는 `{language}`로
지시)이며, 기본 명령은 앱에 내장되고 사용자 명령은 사용자 소유다.

#### Scenario: 재시작 후 설정 유지
- **WHEN** 설정 필드를 편집한 뒤 앱을 재시작하면
- **THEN** 편집한 값이 유지되어 그대로 적용된다

#### Scenario: 기본 명령 제공
- **WHEN** 처음 실행하면
- **THEN** 영어 템플릿에 `{language}` 출력 지시를 담은 `news`
  명령이 등록되어 있다
