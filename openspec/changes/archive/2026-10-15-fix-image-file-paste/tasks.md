# Tasks

## 1. 수정

- [x] 1.1 `interceptPaste`에 이미지 우선 판정 추가: pasteboard에 이미지
  데이터가 있고 문자열이 비었거나 파일 URL 경로면 이미지 경로로 확정
  (지원 모델 → 스테이징, 미지원 → 안내, 둘 다 이벤트 삼킴) — `swift
  build` 통과로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 스크린샷 파일 복사 → ⌘V → 경로가 아니라 이미지
  칩(flash 모델) 또는 거부 안내(미지원), 클립보드 캡처·일반 텍스트
  붙여넣기·긴 텍스트 회귀 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-fix-image-file-paste/`로 이동
