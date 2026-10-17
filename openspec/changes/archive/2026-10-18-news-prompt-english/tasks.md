# Tasks

- [x] 1.1 `defaultCommands`의 news 프롬프트를 영어 템플릿 + "write the
  digest in <시스템 기본 언어>" 보간으로 교체, `systemLanguageName`을
  nonisolated로 공개 + SelfTest 갱신(영어 프롬프트·언어 지시 포함) —
  selftest 통과로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 앱 재시작 → 설정의 news 프롬프트가 영어 +
  시스템 언어 지시, `/news` 전개·전송 정상

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-news-prompt-english/`로 이동
