# Tasks

- [x] 1.1 PageFetcher strip을 2단계로 재구성(전체 HTML 블록 제거 → 500k
  절단 → 태그 스캔) + SelfTest(절단 경계를 넘는 거대 style 블록 제거
  불변식) — selftest 통과로 확인
- [x] 1.2 폴백 렌더러를 WKWebView(JS 실행, 로드 완료 또는 3초 캡,
  body.innerText 추출)로 교체, NSAttributedString 경로 제거 — `swift
  build` 통과로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: `/news` 다이제스트에 CNN 헤드라인 포함(스타일 코드
  아님), 네이버·HN·BBC 회귀 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-cnn-js-render/`로 이동
