# Proposal

## Why

ChatModel.swift(399줄)이 대화 상태, 설정 영속화, 웹 페이지 fetch, 프롬프트
조립, SSE 스트리밍을 모두 떠안고 있다. 스펙 4종(llm-provider, settings,
chat-conversation, menubar-presence)이 이미 기능 경계를 정의하는데 코드가
그 절단선을 따르지 않아, 기능을 추가할 때마다 한 파일이 계속 커진다.

## What Changes

- ChatModel에서 세 타입을 추출한다 (동작 변화 없음 — 순수 리팩터링):
  - `LLMClient` — chat completions 요청 조립 + SSE 스트리밍 + 델타 파싱
    (llm-provider 스펙의 구현 대응물)
  - `SettingsStore` — 설정 6종 @Published + UserDefaults 로드/저장
    (settings 스펙의 구현 대응물)
  - `PageFetcher` — URL 추출, 페이지 fetch, HTML→텍스트 변환, og:image
- SettingsStore는 `environmentObject`로 별도 주입해 SettingsView가 직접
  관찰한다. 중첩 ObservableObject의 변경 전파 문제를 publisher 포워딩
  없이 해결하는 방식이다.
- ChatModel은 대화 상태(messages, draft, UI 플래그)와 오케스트레이션
  (send/stop/clear/copyAnswer), 프롬프트 조립(apiContent와 헬퍼)만 남는다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

(없음 — 요구사항 수준 동작 변화가 없으므로 이 변경은 스펙 델타를 만들지
않는다. `.openspec.yaml`에 `skip_specs: true` 설정.)

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — 축소 (~399줄 → 약 200줄)
- 신규 파일: `LLMClient.swift`, `SettingsStore.swift`, `PageFetcher.swift`
- `Sources/MenuBarChat/ContentView.swift` — SettingsView가 SettingsStore를
  직접 관찰하도록 참조 교체
- `Sources/MenuBarChat/MenuBarChatApp.swift` — environmentObject 2중 주입
  한 줄 추가
- 스펙 4종은 그대로. UserDefaults 키, 요청 형식, UI 동작 모두 불변.
  검증은 `swift build`와 `./openspec-all-build.sh`로 한다.
