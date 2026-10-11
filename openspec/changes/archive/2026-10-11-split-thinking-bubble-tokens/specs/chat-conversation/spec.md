## MODIFIED Requirements

### Requirement: 스트리밍 표시
SSE로 응답을 스트리밍하며, `reasoning_content` 델타는 답변 위에 별도의
작은 글씨 회색 말풍선으로, `content` 델타는 답변 본문(기본 크기 말풍선)으로
덧붙이고, 최신 메시지로 자동 스크롤한다. 스트림은 `[DONE]` 데이터 라인에서
끝난다.

#### Scenario: 추론을 동반한 모델 응답
- **WHEN** 모델이 추론 후 본문을 스트리밍하면
- **THEN** 추론이 작은 글씨 말풍선으로 먼저 나타나고 이어 기본 크기
  말풍선으로 답변이 표시되며, 침묵하는 멈춤이 없다

## ADDED Requirements

### Requirement: 토큰 소비량 표시
스트림 마지막 청크의 `usage`가 도착하면 해당 어시스턴트 답변 아래에
입력/출력 토큰 수를 작은 캡션으로 표시한다. `usage`가 없는 응답(오류,
중단 포함)은 아무 표시도 하지 않는다.

#### Scenario: 정상 응답 완료
- **WHEN** 마지막 청크에 `usage`의 `prompt_tokens`, `completion_tokens`가 포함되면
- **THEN** 답변 말풍선 아래에 "↑<입력 토큰> ↓<출력 토큰>" 캡션이 표시된다

#### Scenario: 중단된 스트림
- **WHEN** 사용자가 스트림을 중단해 `usage`가 도착하지 않으면
- **THEN** 토큰 수 캡션 없이 부분 텍스트만 남는다
