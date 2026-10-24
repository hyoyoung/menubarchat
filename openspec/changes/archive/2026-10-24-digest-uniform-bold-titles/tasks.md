# Tasks

- [x] 1.1 내장 news 프롬프트 서식 지시 교체: "Format each entry as:
  **[Title](URL)** — one-line summary; when the URL is uncertain, use
  **Title** — summary." (기울임 분기 삭제) + SelfTest 기대값 갱신 —
  selftest 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: /news — STEM·일반 모든 섹션에서 제목이 균일하게
  굵게·본문 보통, 링크 있는 제목 클릭 시 기사 열림, 기울임 항목 소멸

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-digest-uniform-bold-titles/`로 이동
