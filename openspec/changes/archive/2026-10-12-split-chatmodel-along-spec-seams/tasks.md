# Tasks

## 1. PageFetcher 추출

- [x] 1.1 `PageFetcher.swift` 신규 파일에 `FetchedPage`와
  `urls(in:)`, `fetchPage(_:)`, `ogImage(in:)`, `plainText(fromHTML:)`,
  `stripTags(_:)`를 이동하고 ChatModel의 호출부를
  `PageFetcher.xxx`로 갱신 — `swift build` 경고 없이 통과로 확인
- [x] 1.2 ChatModel에서 관련 구현이 모두 사라졌는지 grep
  (`plainText|stripTags|ogImage`) 로 확인

## 2. SettingsStore 추출

- [x] 2.1 `SettingsStore.swift` 신규 파일에 설정 6종 @Published와
  init 로딩(UserDefaults + 환경변수 폴백)을 `@MainActor
  ObservableObject`로 이동 — `swift build` 통과로 확인
- [x] 2.2 ChatModel이 `let settings = SettingsStore()`를 소유하고
  기존 `apiKey` 등 참조를 `settings.apiKey`로 갱신 — `swift build`
  통과로 확인

## 3. LLMClient 추출

- [x] 3.1 `LLMClient.swift` 신규 파일에 `StreamError`, `Delta`,
  `decodeDelta(_:)`, `stream(...)`(값 파라미터 + delta 시퀀스 반환,
  D3 형태)를 이동 — `swift build` 통과로 확인
- [x] 3.2 ChatModel의 `send()`가 LLMClient를 호출해 delta를
  받아 `appendToAssistant`로 붙이도록 결선 (Task 취소·에러 처리는
  ChatModel에 유지) — `swift build` 통과로 확인

## 4. 뷰 결선

- [x] 4.1 `MenuBarChatApp.swift`에서
  `.environmentObject(chat.settings)` 주입 추가 — `swift build`
  통과로 확인
- [x] 4.2 `SettingsView`를 `@EnvironmentObject var settings:
  SettingsStore`로 교체 — `swift build` 통과로 확인

## 5. 통합 검증

- [x] 5.1 `./openspec-all-build.sh` 통과 (스펙 점검 + 릴리스 빌드)
- [x] 5.2 `swift run`으로 수동 확인: 설정 편집이 즉시 화면 반영,
  모델 "Custom…" 선택 시 직접 입력란 노출, URL 붙여넣기 → 페이지
  미리보기, 스트리밍/중단/복사 동작 불변

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-split-chatmodel-along-spec-seams/`로
  이동 (skip_specs 변경이라 스펙 갱신은 없음)
