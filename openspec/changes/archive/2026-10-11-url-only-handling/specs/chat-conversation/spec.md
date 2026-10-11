## MODIFIED Requirements

### Requirement: 웹 페이지 읽기
사용자 메시지에 `http(s)` URL이 포함되면 전송 전에 **첫 번째 URL 1개**의
페이지를 내려받아 본문 텍스트(HTML → 텍스트 변환, 최대 2만 자)를 추출한다.
가져온 페이지에는 세션 증가 ID(`ID1`, `ID2`, …)를 부여하고, 미리보기
말풍선(og:image 썸네일 + ID + 도메인 + 본문 첫 줄)을 표시한다.

본문은 그 페이지가 붙은 사용자 메시지가 마지막 메시지인 요청에만 해당
메시지 `content` 끝에 덧붙는다. 메시지가 URL 하나뿐이면 그 뒤에 설정의
URL 지시문을 `[Instruction: <지시문>]` 형태로 덧붙인다. 이후 요청에서는
해당 메시지 자리에 `[Page ID<n> (<도메인>) — mention "ID<n>" to re-include]`
스텁만 담는다. 마지막 사용자 메시지가 `ID<n>`을 언급하면 해당 ID의 본문을
그 요청에 다시 덧붙인다. 가져오기 실패 시 미리보기 말풍선에 간결한
오류("HTTP <코드>", "timeout", "network error", "no content", "invalid URL")를
표시하며 본문과 스텁 모두 담지 않는다.
