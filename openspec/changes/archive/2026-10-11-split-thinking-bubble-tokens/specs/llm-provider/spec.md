## MODIFIED Requirements

### Requirement: SSE 파싱
응답 스트림에서 `data:` 라인을 파싱하고 `[DONE]`에서 멈춘다. 델타에
`content`도 `reasoning_content`도 없는 이벤트는 무시하되, `usage` 객체가
있는 이벤트는 입력/출력 토큰 수로 해석해 현재 어시스턴트 메시지에
기록한다.

#### Scenario: 마지막 청크의 usage
- **WHEN** 마지막 청크에 `usage`(`prompt_tokens`, `completion_tokens`)가 포함되면
- **THEN** 해당 값이 답변 메시지의 토큰 소비량으로 기록된다
