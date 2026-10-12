# Spec Delta

## ADDED Requirements

### Requirement: YouTube 자막 읽기
URL이 YouTube 동영상(watch 또는 youtu.be)이면 페이지 본문 대신 자막
텍스트를 본문으로 사용한다. 자막은 수동 자막을 자동 생성보다 우선하고,
시스템 언어, 영어, 첫 번째 순으로 트랙을 고르며 최대 2만 자로 자른다.
자막을 얻을 수 없으면 페이지 메타데이터(og:title, og:description)를 본문으로
사용하고 본문 첫 줄에 "Video metadata (no captions): <제목>" 마커로
메타데이터 기반 요약임을 나타낸다. 메타데이터도 없으면 기존 실패
오류("no content", "network error" 등)로 미리보기에 표시한다. 미리보기
형식, 첨부 ID, 마지막 요청 전문 첨부와 이후 스텁 대체, URL 지시문 요약은
웹 페이지 읽기 요구사항을 그대로 따른다.

#### Scenario: YouTube URL 요약
- **WHEN** 자막이 있는 YouTube URL만 붙여넣어 보내면
- **THEN** 자막이 첨부되어 URL 지시문에 따라 요약으로 답한다

#### Scenario: 자막 없는 영상의 메타데이터 요약
- **WHEN** 자막이 없는 YouTube URL을 보내면
- **THEN** 메타데이터가 첨부되어 요약으로 답하고 본문 첫 줄에 메타데이터 기반임이 표시된다

#### Scenario: 메타데이터도 없는 영상
- **WHEN** 자막과 메타데이터 모두 없는 YouTube URL을 보내면
- **THEN** 가져오기 실패 오류 미리보기가 표시되고 대화는 계속된다
