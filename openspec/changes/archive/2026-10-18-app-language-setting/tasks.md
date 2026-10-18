# Tasks

- [x] 1.1 SettingsStore: `appLanguage` 필드(기본 시스템 언어, UserDefaults),
  urlHandling 기본값을 `summarize it in {language}`로, 시드 news 프롬프트를
  `{language}` 사용으로 교체 + SelfTest — selftest 통과로 확인
- [x] 1.2 치환 적용: `SlashCommands.expand` 결과와 PromptComposer 지시문
  부착에서 `{language}` → settings.appLanguage (ChatModel이 언어 전달)
  + SelfTest(치환 회귀) — selftest 통과로 확인
- [x] 1.3 설정에 Language Picker(프리셋 + Custom) 추가 — `swift build`
  통과로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: 언어를 Japanese로 변경 → `/news` 다이제스트가
  일본어, URL 요약 지시문도 일본어 → Korean으로 복귀 확인, 재시작 후
  유지

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-app-language-setting/`로 이동
