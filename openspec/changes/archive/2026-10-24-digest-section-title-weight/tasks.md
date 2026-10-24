# Tasks

- [x] 1.1 내장 news 프롬프트 서식 지시를 섹션별 분리(STEM 굵게·일반
  보통, "the same way except" 연결) + SelfTest 기대값 갱신 — selftest
  통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: /news — STEM 제목만 굵게, 일반 제목·본문 보통,
  양쪽 링크 클릭·반복 제거 유지

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-digest-section-title-weight/`로 이동
