# Tasks

## 1. 모델

- [x] 1.1 ChatModel에 `stagedPaste`, `pasteNotice`(3초 자동 소멸) 상태,
  칩 조작(clearStaged/unstageToDraft), `send()`의 스테이징 본문 결합
  (초안 + 개행 + 스테이징) 추가 — `swift build` 통과로 확인

## 2. 가로채기

- [x] 2.1 AppDelegate에 ⌘V 로컬 모니터 추가(채팅 패널 키윈도우 + 설정
  닫힘 조건, D1 판정: 무텍스트→안내·삼킴, 10줄 초과→스테이징·삼킴,
  그 외 통과) — `swift build` 통과로 확인

## 3. 표시

- [x] 3.1 ContentView에 붙여넣기 칩(첫 줄 + N줄 + 휴지통 + 연필)과
  거부 안내 캡션 추가 — `swift build` 통과로 확인

## 4. 검증

- [x] 4.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 4.2 수동 확인: 긴 텍스트 붙여넣기 → 즉시 칩·빈 입력란·버벅임 없음,
  전송 시 `ID<n>p` 카드·전문 첨부, 칩 휴지통/연필 동작, 이미지만
  붙여넣기 → 안내, 짧은 텍스트 → 평범한 삽입, 설정 열림 상태 → 제한
  미적용

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-limit-paste-formats/`로 이동
