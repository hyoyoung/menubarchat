# Tasks

- [x] 1.1 내장 news 프롬프트: 서식 지시를 "Format every entry in both
  sections as: …"로 교체, 일반 뉴스 문장에 "formatted the same way"
  추가 + SelfTest 기대값 갱신 — selftest 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: /news — STEM·일반 양쪽 모든 제목이 균일하게 굵게·
  본문 보통 (섹션 간 차등 소멸)

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-digest-format-both-sections/`로 이동
