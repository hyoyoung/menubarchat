# Spec Delta

## MODIFIED Requirements

### Requirement: 웹 페이지 읽기
10줄 이하 사용자 메시지에 `http(s)` URL이 포함되면 전송 전에 첫 번째 URL
1개의 페이지를 내려받아 본문 텍스트(HTML → 텍스트 변환, 최대 2만 자)를
추출하고 통합 첨부 카운터로 `ID<n>`을 부여한다. 미리보기 말풍선(og:image
썸네일 + ID + 도메인 + 본문 첫 줄)을 표시한다.

본문은 그 메시지가 마지막 메시지인 요청에만 `content` 끝에 덧붙고, 이후
요청부터는 해당 메시지 자리를 `[Page ID<n> (<도메인>)]` 스텁으로
대체한다. 가져오기 실패 시 미리보기 말풍선에
간결한 오류("HTTP <코드>", "timeout", "network error", "no content",
"invalid URL")를 표시한다.

#### Scenario: 긴 붙여넣기 안의 URL
- **WHEN** 10줄 초과 붙여넣기 텍스트 안에 URL이 포함되어 있으면
- **THEN** 해당 URL을 가져오지 않고 붙여넣은 텍스트만 전송된다

### Requirement: 긴 붙여넣기 접기
10줄을 초과하는 붙여넣기 텍스트는 전송 즉시 접힌 카드(첫 줄
말줄임 + "붙여넣은 텍스트 · N줄")로 표시하고 More/Less로 펼친다. 접힘
라벨은 추론 말풍선과 같은 형식으로 ID를 오른쪽에 함께 표시한다
("More, ID<n>p"). 통합 첨부 카운터로 `ID<n>p`를 부여한다. 전문은 그
메시지가 마지막 메시지인 요청에만 `[Pasted text ID<n>p]` 태그와 함께
담고, 이후 요청부터는 `[Text ID<n>p (<첫 줄>)]` 스텁으로 대체한다.

#### Scenario: 긴 붙여넣기 카드
- **WHEN** 사용자가 10줄을 초과하는 텍스트를 붙여넣어 보내면
- **THEN** 접힌 카드로 표시되고 그 요청에만 `[Pasted text ID<n>p]` 태그와 함께 전문이 전송된다

#### Scenario: 접힘 라벨의 ID
- **WHEN** 접힌 붙여넣기 카드의 More/Less 라벨을 보면
- **THEN** 라벨 오른쪽에 `ID<n>p`가 표시된다
