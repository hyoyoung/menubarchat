# Tasks

## 1. 변환기

- [x] 1.1 `MathFormatter.swift` 추가(구간 감지·기호 사전·첨자·frac·
  언랩, D2 순서) + SelfTest 5건(제안 예시, 그리스+분수, 알 수 없는
  명령 유지, 통화 미변환, 수식 외 무변경) — selftest 통과로 확인

## 2. 적용

- [x] 2.1 `MessageView.markdown()` 시작점에 변환 삽입 — `swift build`
  통과로 확인

## 3. 검증

- [x] 3.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 3.2 수동 확인: 수식 포함 질문(예: "attention 수식 보여줘") →
  Σ·첨자·그리스가 변환되어 표시, 일반 텍스트·기존 마크다운 무변화,
  통화 표기 무변화

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-render-math-unicode/`로 이동
