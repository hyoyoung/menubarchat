# Tasks

- [x] 1.1 대기 표시 행에 `.id("placeholder")` 부여, 팔로우 scrollTo의
  대상을 "대기 표시가 보이면 그 행, 아니면 마지막 메시지"로 교체 —
  `swift build` 통과로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: "답변 생성 중…" 상태에서 바닥으로 스크롤 → 델타가
  도착해도 위로 점프하지 않고 스피너·문구가 화면에 남는지, 위로 스크롤
  시 팔로우 끊김·점프 버튼 회귀 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-scroll-pin-placeholder/`로 이동
