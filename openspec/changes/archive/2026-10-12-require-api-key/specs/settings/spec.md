# Spec Delta

## ADDED Requirements

### Requirement: API 키 부재 시 전송 차단
API 키가 비어 있으면(공백만 포함) 채팅 요청을 보내지 않고 어시스턴트 오류
말풍선으로 안내한다. 사용자 초안은 지워지지 않고 유지된다.

#### Scenario: 빈 키로 전송
- **WHEN** API 키 없이 메시지를 전송하면
- **THEN** 요청 없이 오류 말풍선이 안내를 표시하고 초안은 남아 있다
