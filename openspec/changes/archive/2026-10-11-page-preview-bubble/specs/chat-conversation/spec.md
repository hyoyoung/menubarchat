## MODIFIED Requirements

### Requirement: 웹 페이지 읽기
사용자 메시지에 `http(s)` URL이 포함되면 전송 전에 **첫 번째 URL 1개**의
페이지를 내려받아 본문 텍스트(HTML → 텍스트 변환, 최대 2만 자)를 추출하고,
해당 사용자 메시지의 API `content` 끝에 덧붙인다. 사용자 말풍선 아래에는
미리보기 말풍선(og:image 썸네일 + 도메인 + 본문 첫 줄)을 표시한다.
가져오기에 실패하면 미리보기 말풍선에 간결한 오류("HTTP <코드>",
"timeout", "network error", "no content", "invalid URL")를 표시하고 API
content에는 덧붙지 않는다.

#### Scenario: URL을 포함한 질문
- **WHEN** 사용자가 URL과 함께 질문을 보내면
- **THEN** 첫 번째 URL의 페이지 본문이 요청 컨텍스트에 포함되고, 미리보기 말풍선(og:image + 첫 줄)이 표시되며, 모델이 그 내용을 근거로 답한다

#### Scenario: 페이지 접근 실패
- **WHEN** URL이 존재하지 않거나 15초 안에 응답하지 않으면
- **THEN** 미리보기 말풍선에 간결한 오류가 표시되고 본문은 전송되지 않는다
