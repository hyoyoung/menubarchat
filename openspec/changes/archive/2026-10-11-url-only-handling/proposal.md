# 제안: URL 단독 입력 기본 처리 지시문

## 왜

URL만 입력해 보내면 모델에게 "뭘 하라"는 지시가 없어 답변이 들쭉날쭉하다.
URL 단독 입력에 붙일 기본 지시문을 설정에서 바꿀 수 있게 한다.

## 무엇을

- 사용자 메시지가 URL 하나뿐(다른 텍스트 없음)이면, 그 메시지가 마지막
  메시지인 요청의 `content` 끝에 `[Instruction: <지시문>]`을 덧붙인다.
  말풍선 표시는 URL 그대로다.
- 지시문 기본값은 `summarize it`. 설정 섹션에 "http/https default
  handling" 입력란으로 편집하고 `urlHandling` 키로 UserDefaults에
  저장한다. 비워 두면 지시문을 붙이지 않는다.
