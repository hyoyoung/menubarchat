# Design

## Context

ChatModel이 6개 책임을 떠안은 단일 ObservableObject다. 스펙 4종이 이미
기능 경계를 정의하며, 이 변경은 코드를 그 절단선에 맞추는 순수
리팩터링이다. 제약: Command Line Tools만으로 빌드(@State/@StateObject
등 SwiftUI 매크로 불가 → 상태는 ObservableObject의 @Published로만),
서드파티 의존성 없음, 단일 사용자 로컬 앱.

## Goals / Non-Goals

**Goals:**

- ChatModel을 대화 상태 + 오케스트레이션으로 축소, 나머지는 스펙 대응
  타입 3개로 이동 (동작·UI·UserDefaults 키 불변)
- 설정 변경이 뷰에 전파되도록 관찰 구조 확보

**Non-Goals:**

- 프롬프트 조립(apiContent와 헬퍼)의 추출 — messages 전체와
  settings.urlHandling에 결합된 이 변경의 결합 허브라 지금 분리하면
  이득 없이 간접층만 생긴다
- 테스트 타깃 신설, 프로토콜/의존성 주입 추상화, 파일 재배치 외의
  구조 변경

## Decisions

### D1: 절단선은 스펙 4종을 따른다

`LLMClient` ← llm-provider 스펙(stream, decodeDelta, StreamError),
`SettingsStore` ← settings 스펙(설정 6종 + UserDefaults),
`PageFetcher` ← chat-conversation 스펙의 웹 페이지 읽기 요구사항
(urls, fetchPage, plainText, stripTags, ogImage). 계약이 스펙으로
고정된 부분부터 자르는 것이 안전해서다. 대안이었던 "순수 함수만
이동"(C안)은 설정·대화 결합을 남긴다.

### D2: SettingsStore 전파는 environmentObject 2중 주입으로 해결

중첩 ObservableObject는 바깥 객체에 변경을 전파하지 않는다. 대안은
(a) publisher 포워딩 — Combine 배관 추가 + ChatModel이 설정 변경을
전부 다시 뿌리는 반쪽짜리 결합 잔존, (b) SettingsStore 별도 주입.
설정을 읽는 뷰는 SettingsView뿐이므로 (b)가 더 단순하다:
`ContentView().environmentObject(chat).environmentObject(chat.settings)`,
SettingsView는 `@EnvironmentObject var settings: SettingsStore`로 교체.
ChatModel은 send() 시점에 값만 읽는다(관찰 불필요).

### D3: LLMClient는 값만 받는 스트리밍 함수

`LLMClient.stream(baseURL:apiKey:model:thinkingBudget:webSearch:messages:)`
형태로 필요한 값을 파라미터로 받아 delta 시퀀스를 반환하고, messages
변경(appendToAssistant)과 Task 수명 관리는 ChatModel에 남긴다. 클라
이언트가 상태를 모르게 해 재결합을 막기 위해서다. Delta 구조체와
StreamError는 LLMClient.swift로 이동한다.

### D4: 타입 배치

`FetchedPage`는 PageFetcher.swift로, `Message`는 ChatModel.swift에
잔류(UI 말풍선 상태 필드를 가짐). PageFetcher는 상태가 없어
case 없는 enum 네임스페이스 또는 static 구조체로 둔다.

## Risks / Trade-offs

- [SettingsView 전파 누락으로 설정 편집이 화면에 안 반영됨]
  → D2 채택으로 원천 차단. 빌드 후 Custom… 모델 입력란 노출 흐름을
  수동 확인한다.
- [이동 중 미세한 동작 변화(에러 처리, 취소 처리)] → 로직은 복사 후
  결선만 변경. `swift build` 경고 0 + `./openspec-all-build.sh`로 검증.
- [파일 3개 증가로 탐색 비용] → 각 파일이 스펙 1:1 대응이라 오히려
  스펙→코드 추적이 쉬워진다.

## Migration Plan

1. PageFetcher, SettingsStore, LLMClient 순서로 타입 추출(컴파일 유지)
2. ChatModel/ContentView/MenuBarChatApp 결선
3. `swift build` → `./openspec-all-build.sh`
4. 롤백은 커밋 revert로 충분 (UserDefaults 키·형식 불변, 데이터
   마이그레이션 없음)
