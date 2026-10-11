## MODIFIED Requirements

### Requirement: 사고(thinking) 예산
설정의 사고 수준(`low`/`medium`/`high`/`max`, 기본 `low`)을
`{"budget": <수준>}`으로 요청하며, 상시 사고 모델(glm-5.x)이 1210 오류로
거부하는 `thinking.type`은 절대 보내지 않는다.
