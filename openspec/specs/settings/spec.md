# 설정 기능 스펙

## Purpose

패널 안에서 편집하고 실행 간에 유지되는 LLM 엔드포인트 런타임 구성.

## Requirements

### Requirement: 설정 필드
패널 내 설정 섹션에 "API key" 비밀 필드, "Base URL" 필드, 모델 선택(프리셋
`glm-5.3-flash`/`glm-5.3`/`glm-4.6` + `Custom…` 직접 입력), 사고 수준
선택(`low`/`medium`/`high`/`max`), 웹 검색 토글, "URL handling" 지시문
필드를 제공한다.

#### Scenario: 프리셋 없는 모델 직접 입력
- **WHEN** 모델 선택에서 "Custom…"을 고르고 모델 이름을 입력하면
- **THEN** 입력한 이름이 요청 모델로 저장되어 사용된다

### Requirement: 영속화
편집 즉시 `apiKey`, `baseURL`, `model`, `thinkingBudget`, `webSearch`,
`urlHandling`을 UserDefaults에 저장하고 실행 시 불러온다. 기본값: base
URL `https://api.z.ai/api/coding/paas/v4`, 모델 `glm-5.3-flash`, 사고 수준
`high`, 웹 검색 끔, URL 지시문 `summarize it in <시스템 기본 언어>`, API
키는 환경변수 `ZAI_API_KEY`(그 다음 `Z_AI_API_KEY`).

#### Scenario: 재시작 후 설정 유지
- **WHEN** 설정 필드를 편집한 뒤 앱을 재시작하면
- **THEN** 편집한 값이 유지되어 그대로 적용된다

### Requirement: 설정 표시 여부
기어 버튼으로 설정 섹션을 토글하며, 열려 있는 동안 채워진 기어
아이콘(`gearshape.fill`)을 표시한다. 패널이 닫히거나, 메시지를 보내거나,
Escape를 누르면 자동으로 숨겨진다.

#### Scenario: Escape로 설정 닫기
- **WHEN** 설정이 열려 있고 Escape를 누르면
- **THEN** 설정 섹션이 숨겨지고 채팅은 그대로 남는다

### Requirement: API 키 부재 시 전송 차단
API 키가 비어 있으면(공백만 포함) 채팅 요청을 보내지 않고 어시스턴트 오류
말풍선으로 안내한다. 사용자 초안은 지워지지 않고 유지된다.

#### Scenario: 빈 키로 전송
- **WHEN** API 키 없이 메시지를 전송하면
- **THEN** 요청 없이 오류 말풍선이 안내를 표시하고 초안은 남아 있다
