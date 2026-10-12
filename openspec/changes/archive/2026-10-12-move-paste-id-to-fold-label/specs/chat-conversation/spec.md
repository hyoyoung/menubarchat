# Spec Delta

## MODIFIED Requirements

### Requirement: 긴 붙여넣기 접기
사용자 메시지가 10줄을 초과하면 접힌 카드(문서 아이콘 + 첫 줄 한 줄
말줄임 + "붙여넣은 텍스트 · N줄")로 표시하고 More/Less로 펼친다. 접힘
라벨은 추론 말풍선과 같은 형식으로 ID를 오른쪽에 함께 표시한다
("More, ID<n>p"). 통합 첨부 카운터로 `ID<n>p`를 부여한다. 전문은 그
메시지가 마지막 메시지인 요청에만 `[Pasted text ID<n>p]` 태그와 함께
담고, 이후 요청부터는 `[Text ID<n>p (<첫 줄>) — mention "ID<n>p" to
re-include]` 스텁으로 대체한다.

#### Scenario: 긴 붙여넣기 카드
- **WHEN** 사용자가 10줄을 초과하는 텍스트를 붙여넣어 보내면
- **THEN** 접힌 카드로 표시되고 그 요청에만 `[Pasted text ID<n>p]` 태그와 함께 전문이 전송된다

#### Scenario: 접힘 라벨의 ID
- **WHEN** 접힌 붙여넣기 카드의 More/Less 라벨을 보면
- **THEN** ID<n>p가 라벨 오른쪽에("More, ID<n>p") 함께 표시된다
