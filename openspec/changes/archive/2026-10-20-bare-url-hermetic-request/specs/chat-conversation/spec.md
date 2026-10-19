# Spec Delta

## MODIFIED Requirements

### Requirement: 기본 지시문
사용자 메시지가 URL 하나뿐이거나 긴 붙여넣기(10줄 초과)면, 그 메시지가
마지막 메시지인 요청의 `content` 끝에 설정의 지시문을 `[Instruction:
<지시문> — unless the user already asked something specific above]` 형태로
덧붙인다. 지시문 텍스트의 `{language}`는 전송 시점에 Language 설정의
언어명으로 치환한다. 지시문이 비어 있으면 덧붙이지 않고, 말풍선 표시는
원문 그대로다. 기본값과 편집은 설정 스펙을 따른다. URL 하나뿐인 메시지의
요청은 밀폐다 — 그 메시지(본문 + 지시문)만 전송하고 과거 사용자
메시지·명령 스텁·페이지 스텁 등 어떤 이전 맥락도 포함하지 않는다. URL과
텍스트가 섞인 메시지는 밀폐 대상이 아니며 기존 전체 맥락 규칙을 따른다.

#### Scenario: URL만 입력
- **WHEN** 사용자가 URL만 붙여넣어 보내면
- **THEN** 기본 지시문이 적용되어 모델이 요약으로 답한다

#### Scenario: 사용자 지시와 함께 붙여넣기
- **WHEN** 사용자가 자신의 지시(예: "원인 찾아줘")와 함께 긴 텍스트를 붙여넣으면
- **THEN** 기본 지시문보다 사용자 지시가 우선 적용된다

#### Scenario: URL-only 요청은 밀폐
- **WHEN** 명령 실행 이력이 있는 대화에서 URL 하나만 전송하면
- **THEN** 요청은 그 URL 메시지와 지시문만 담고 과거 명령 스텁·페이지
    스텁·이전 URL은 포함하지 않는다
