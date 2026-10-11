# Tasks

## 1. 추출

- [x] 1.1 `PromptComposer.swift`에 apiContent와 헬퍼(mentionedAttachments,
  isLongPaste, firstLine, isURLOnly, AttachmentRef)를 static으로 이동하고
  ChatModel 호출부를 교체 — `swift build` 통과로 확인

## 2. 테스트

- [x] 2.1 `SelfTest.swift`(하네스 + 테스트)와 main.swift의 `--selftest`
  분기 추가 — `swift run MenuBarChat --selftest` 실행 확인
- [x] 2.2 스텁 대체 테스트: 비마지막 사용자 메시지(붙여넣기·페이지)는
  스텁으로, 마지막은 전문으로 조립 — `swift test` 통과로 확인
- [x] 2.3 재포함 테스트: 마지막 메시지의 ID 언급이 전문을 재부착하고
  중복하지 않음 — `swift test` 통과로 확인
- [x] 2.4 지시문 테스트: URL만 입력·긴 붙여넣기에 부착, 일반 입력·빈
  지시문은 부착 안 함 — `swift test` 통과로 확인

## 3. 통합 검증

- [x] 3.1 `./openspec-all-build.sh` 통과

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-test-prompt-assembly/`로 이동
