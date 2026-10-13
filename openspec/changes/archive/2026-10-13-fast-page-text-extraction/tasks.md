# Tasks

## 1. 재구성

- [x] 1.1 `plainText(fromHTML:)`을 strip-우선으로 재구성: 충분한
  strip(≥200자) 즉시 반환, 빈약 시 WebKit 임포터(`.userInitiated`,
  2초 캡) 대기 후 폴백 — `swift build` 통과로 확인

## 2. 테스트

- [x] 2.1 SelfTest: 충분한 텍스트에서 임포터 미호출, 빈약 시 임포터
  결과 채택, 임포터 실패/타임아웃 시 strip 반환 — `swift run
  MenuBarChat --selftest` 통과로 확인

## 3. 검증

- [x] 3.1 `./openspec-all-build.sh` 통과
- [x] 3.2 수동 확인: 일반 웹페이지 URL 붙여넣기 시 미리보기가 수 초
  (≈5s) 대기 없이 1초 이내로 뜨는지, 추출 본문 품질 유지

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-fast-page-text-extraction/`로 이동
