# 제안: 설정에 모델 프리셋과 사고(thinking) 수준 추가

## 왜

모델을 바꾸려면 정확한 이름을 알고 직접 타이핑해야 한다. 기본은
glm-5.3-flash를 쓰지만 가끔 glm-5.3이 필요하므로 원클릭 전환이 필요하다.
또한 사고 수준이 `low`로 하드코딩되어 있어 깊은 추론이 필요한 질문에
대응하지 못한다.

## 무엇을

- 모델 설정을 프리셋 Picker로 바꾼다: `glm-5.3-flash`(기본), `glm-5.3`,
  `glm-4.6`, `Custom…`(선택 시 자유 입력 필드 표시).
- 사고 수준 Picker를 추가한다: `low`(기본) / `medium` / `high` / `max`.
  선택값을 `thinkingBudget` UserDefaults 키로 저장하고 요청 본문
  `thinking: {"budget": <수준>}`에 반영한다.
- `off`는 제공하지 않는다 — GLM-5.3 계열은 thinking 비활성화가 불가
  (Z.AI 문서). budget 값 low/medium/high/max는 실측으로 모두 200 확인.
- 정정: settings 스펙의 기본 모델이 이전 변경에서 `glm-5.3`으로 남아
  있었는데 실제 기본값은 `glm-5.3-flash`이므로 이번에 바로잡는다.
