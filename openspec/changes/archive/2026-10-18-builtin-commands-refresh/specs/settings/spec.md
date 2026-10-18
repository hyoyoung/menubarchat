# Spec Delta

## MODIFIED Requirements

### Requirement: 설정 필드
패널 내 설정 섹션에 "API key" 비밀 필드, "Base URL" 필드, 모델 선택(프리셋
`glm-5.3-flash`/`glm-5.3`/`glm-4.6` + `Custom…` 직접 입력), 사고 수준
선택(`low`/`medium`/`high`/`max`), 웹 검색 토글, "URL handling" 지시문
필드, "Language" 선택(프리셋 Korean/English/Japanese/Chinese/Spanish +
`Custom…` 직접 입력), 커스텀 명령 목록 편집기를 제공한다. 편집기는 기본
명령(읽기 전용 표시)과 사용자 명령(이름 + 프롬프트 쌍의 추가·수정·삭제)을
구분해 보여준다.

#### Scenario: 프리셋 없는 모델 직접 입력
- **WHEN** 모델 선택에서 "Custom…"을 고르고 모델 이름을 입력하면
- **THEN** 입력한 이름이 요청 모델로 저장되어 사용된다

#### Scenario: 명령 추가
- **WHEN** 설정에서 이름 `weather`와 프롬프트를 입력해 명령을 추가하면
- **THEN** 입력창에서 `/weather`로 해당 프롬프트를 전개할 수 있다

#### Scenario: 언어 변경 즉시 반영
- **WHEN** Language 설정을 Korean에서 Japanese로 바꾸면
- **THEN** 다음 전송의 `{language}` 치환(지시문·명령 프롬프트)이
  Japanese로 적용된다

#### Scenario: 기본 명령은 읽기 전용
- **WHEN** 편집기에서 기본 명령(`news`) 행을 보면
- **THEN** 기본 표시와 함께 프롬프트가 보이지만 편집·삭제할 수 없다

### Requirement: 영속화
편집 즉시 `apiKey`, `baseURL`, `model`, `thinkingBudget`, `webSearch`,
`urlHandling`, `appLanguage`, 사용자 커스텀 명령 목록을 UserDefaults에
저장하고 실행 시 불러온다. 기본값: base URL `https://api.z.ai/api/coding/paas/v4`,
모델 `glm-5.3-flash`, 사고 수준 `high`, 웹 검색 끔, URL 지시문
`summarize it in {language}`, 언어는 시스템 기본 언어, 사용자 명령 목록은
비어 있음, API 키는
환경변수 `ZAI_API_KEY`(그 다음 `Z_AI_API_KEY`). 기본 명령(`news`)은
앱에 내장되어 저장되지 않으며 항상 최신 정의를 따른다 — 앱 업데이트 후
재시작하면 기본 명령 프롬프트도 업데이트된다.

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
