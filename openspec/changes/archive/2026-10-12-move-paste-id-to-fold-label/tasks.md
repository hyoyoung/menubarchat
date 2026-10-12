# Tasks

## 1. 라벨 교체

- [x] 1.1 MessageView 붙여넣기 카드 캡션에서 " · ID<n>p" 제거,
  More/Less 버튼 라벨에 ", ID<n>p" 접미 추가 — `swift build` 통과로 확인

## 2. 검증

- [x] 2.1 `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 카드 캡션이 "붙여넣은 텍스트 · N줄"이고 접힘 라벨이
  "More, ID<n>p"/"Less, ID<n>p"로 토글되며, 추론 말풍선 라벨과 형식이
  일치

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-move-paste-id-to-fold-label/`로 이동
