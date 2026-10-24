# Spec Delta

## MODIFIED Requirements

### Requirement: 영속화
편집 즉시 `apiKey`, `baseURL`, `model`, `thinkingBudget`, `webSearch`,
`urlHandling`, `appLanguage`, 사용자 커스텀 명령 목록을 UserDefaults에
저장하고 실행 시 불러온다. 기본값: base URL `https://api.z.ai/api/coding/paas/v4`,
모델 `glm-5.3-flash`, 사고 수준 `high`, 웹 검색 끔, URL 지시문
`summarize it in {language}`, 언어는 시스템 기본 언어, 사용자 명령 목록은
비어 있음, API 키는
환경변수 `ZAI_API_KEY`(그 다음 `Z_AI_API_KEY`). 기본 명령(`news`)은
앱에 내장되어 저장되지 않으며 항상 최신 정의를 따른다 — 앱 업데이트 후
재시작하면 기본 명령 프롬프트도 업데이트된다. 내장 `news` 프롬프트는
4개 뉴스 사이트 URL 종합, STEM 뉴스 상위 15개(항목 서식 `**[제목](URL)**
— 한 줄 요약`·URL를 모르면 `**제목** — 한 줄 요약`), 일반 뉴스 상위
15개(같은 형식이되 제목은 보통 — `[제목](URL)`·URL를 모르면 `제목`),
본문은 항상 보통, 링크는 첨부된 Links 목록의 URL만 사용, 전형적 뉴스
언급 없이 제외, 직전 다이제스트 중복 규칙 — STEM 중복은 사소하지 않으면
유지, 일반 뉴스 중복은 중요 전개가 아니면 제외 — 평문 `{previous}`,
출력 언어 `{language}` 지시를 담는다.

#### Scenario: 재시작 후 설정 유지
- **WHEN** 설정 필드를 편집한 뒤 앱을 재시작하면
- **THEN** 편집한 값이 유지되어 그대로 적용된다

#### Scenario: 기본 명령 제공
- **WHEN** 처음 실행하면
- **THEN** 영어 템플릿에 `{language}` 출력 지시를 담은 `news`
  명령이 등록되어 있다

#### Scenario: 기본 명령은 업데이트를 따름
- **WHEN** 기본 명령 프롬프트가 변경된 앱 버전으로 업데이트해 실행하면
- **THEN** `/news` 전개 프롬프트는 저장된 이전 버전이 아니라 새 정의를
  따른다
