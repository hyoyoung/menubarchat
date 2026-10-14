# Tasks

## 1. 인코더

- [x] 1.1 `ImageEncoder.swift` 추가(리사이즈 1568px·JPEG 0.7·Base64
  Data URL, 순수 함수) + SelfTest(2000px 입력 캡·접두 검증) — `swift
  run MenuBarChat --selftest` 통과로 확인

## 2. 모델·게이트

- [x] 2.1 ChatModel: `supportsImageInput`(모델명 "flash" 포함),
  `stagedImage` 슬롯, 전송 시 Message에 이미지·`ID<n>i` 부여 — `swift
  build` 통과로 확인

## 3. 가로채기·UI

- [x] 3.1 AppDelegate 가로채기: 텍스트 없는 이미지 + 지원 모델 →
  스테이징, 미지원 → 기존 안내 — `swift build` 통과로 확인
- [x] 3.2 ContentView: 이미지 칩(썸네일·삭제)과 사용자 말풍선 썸네일
  추가 — `swift build` 통과로 확인

## 4. 프롬프트·전송

- [x] 4.1 PromptComposer: `ID<n>i` 스텁·언급 재포함(정규식 접미 확장),
  이미지 파트 배열 변형 + SelfTest — selftest 통과로 확인
- [x] 4.2 LLMClient: 마지막 메시지 파트 배열 content 전송 — `swift
  build` 통과로 확인

## 5. 검증

- [x] 5.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 5.2 수동 확인: flash 모델에서 스크린샷 붙여넣기 → 칩 → 질의 →
  이미지 이해 답변, `ID<n>i` 언급 재포함, 미지원 모델(예: glm-5.3)에서
  거부 안내, 텍스트+이미지 혼합 시 텍스트만 취함

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-image-input/`로 이동
