# Tasks

## 1. 가드 구현

- [x] 1.1 `ChatModel.send()`에 잘라낸 `settings.apiKey`가 비면 요청을 막고
  어시스턴트 오류 말풍선("Error: API key is empty — open settings")을
  띄우는 가드 추가 — `swift build` 통과로 확인

## 2. 검증

- [x] 2.1 `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 키 비움 상태에서 전송 시 안내 말풍선 표시·초안 유지,
  키 설정 후 정상 스트리밍

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-require-api-key/`로 이동
