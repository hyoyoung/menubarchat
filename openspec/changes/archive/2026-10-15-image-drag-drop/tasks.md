# Tasks

## 1. 붙여넣기 판정 보강

- [x] 1.1 `interceptPaste`에 경로 문자열 판정 추가: pasteboard에 이미지
  데이터가 없더라도 문자열이 이미지 확장자(.png/.jpg/.jpeg/.gif/.webp/
  .tiff/.heic)의 절대 경로이고 파일이 존재하면 이미지 붙여넣기로 처리 —
  `swift build` 통과로 확인

## 2. 드롭 지원

- [x] 2.1 ContentView 채팅 영역에 `dropDestination`(이미지 파일 URL)
  추가: 지원 모델 → 첨부 승격, 미지원 → 안내, 경로 미삽입 — `swift
  build` 통과로 확인

## 3. 검증

- [x] 3.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 3.2 수동 확인: ① 이미지 파일 드롭 → 칩(또는 미지원 안내), 경로
  미삽입 ② 재현했던 붙여넣기 경로 케이스 → 이미지 처리 ③ 텍스트
  붙여넣기·긴 텍스트·URL 회귀 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-image-drag-drop/`로 이동
