# Tasks

- [x] 1.1 바닥 목적지 계산(대기 표시 행 vs 마지막 메시지)을 헬퍼로 통합,
  마커 재개 분기(false→true 전환)에서 즉시 scrollTo 스냅 추가 — `swift
  build` 통과로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 스트리밍 중 위로 스크롤 후 바닥으로 되돌아가면 재개
  스냅이 부드럽고 이후 델타에서 위로 튀는 점프가 사라지는지, 점프 버튼
  회귀 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-bottom-pin-snap/`로 이동
