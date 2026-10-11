# 제안: 웹 검색 도구 활성화와 붙여넣기 단축키 수정

## 왜

모델이 웹 페이지/최신 정보에 접근할 수 없어 URL이나 시사 질문에 답하지
못한다. Z.AI chat completions은 내장 web_search 도구를 지원하므로 요청에
붙이기만 하면 된다. 또한 입력란에서 Cmd+V가 동작하지 않는 버그가 있다.

## 무엇을

- 설정에 "Web search" 토글 추가(기본 켬). 켜면 요청 본문에
  `tools: [{"type": "web_search", "web_search": {"enable": true,
  "search_result": true}}]`를 포함한다. 답변 본문에 [Source: ref_x]
  형태로 출처가 붙는다. 출처 목록 별도 UI는 이번 범위 아니다.
- Cmd+V 버그 수정: 이 앱은 NSApplication을 수동 구성해 메인 메뉴가
  없어 Edit 단축키(Cmd+C/V/X/A/Z)가 동작하지 않는다. 최소 Edit 메뉴를
  NSApp.mainMenu에 설치한다.
