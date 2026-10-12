# 프로젝트 규칙

## 이 프로젝트는

MenuBarChat은 Z.AI GLM 모델과 토큰 단위 스트리밍으로 대화하는 macOS
메뉴 막대 앱입니다. 단일 사용자, 로컬 전용, 서버 구성 요소 없음.

## 작업 절차

자잘한 수정 외 모든 작업은 변경 제안으로 시작한다(`openspec new change`
후 CLI 안내, 구현 전 사용자 승인). `swift build`으로 검증하고
`openspec archive`로 마감한다. `/opsx:*` 명령이 이 절차를 자동화한다.

## 기술 스택 및 제약

- Swift 5.9 / SwiftUI + AppKit (`NSStatusItem`, `NSPanel`, `NSHostingController`)
- macOS 14 이상, Command Line Tools만으로 빌드 — Xcode 프로젝트 없음, 스토리보드 없음
- Swift Package Manager 실행 타깃
- 서드파티 의존성 없음

## 명령어

- 소스에서 바로 실행: `swift run`
- 디버그 빌드: `swift build`
- 스펙 점검 + 앱 빌드: `./openspec-all-build.sh` (스펙 구조를 확인한 뒤
  make-only-app.sh를 호출)
- 독립 앱 번들 빌드: `./make-only-app.sh` → `build/MenuBarChat.app`
  (릴리스 바이너리 + `LSUIElement` 포함 `Info.plist`, 미서명, 로컬 용도).
  컴파일 경고가 있으면 빌드가 실패한다(CommandLineTools search-path
  노이즈는 제외)

## 레이아웃

- `Sources/MenuBarChat/main.swift` — AppKit 진입점 (SwiftUI 씬 없음)
- `Sources/MenuBarChat/MenuBarChatApp.swift` — 상태 항목, 채팅 패널,
  우클릭 정보/종료 메뉴
- `Sources/MenuBarChat/ChatModel.swift` — 대화 상태, SSE 스트리밍,
  설정 영속화
- `Sources/MenuBarChat/ContentView.swift` — 채팅 UI, 설정 UI, 말풍선

## 알려진 플랫폼 함정 (재발 방지)

- 현재 macOS에서는 `App.init()` 시점에 `NSApp`이 nil — 거기서 접근하지
  말 것. 시작 로직은 `NSApplicationDelegate` 콜백에 둘 것
- 실행 시 어떤 창도 표시되어서는 안 됨. 상태 항목만 존재
- Z.AI 상시 사고(thinking) 모델(glm-5.x)은 `thinking.type`을 거부 —
  `thinking: {"budget": "low"}`를 사용할 것
- Command Line Tools만으로 빌드하면 SwiftUI 매크로 플러그인
  (`SwiftUIMacros`)이 없어 `@State`/`@StateObject` 컴파일 불가 — UI
  상태는 `ChatModel`의 `@Published`나 `Message` 필드로 관리할 것

## 환경설정

- UserDefaults 키: `apiKey`, `baseURL`, `model`
- 저장된 값이 없을 때 API 키 환경변수 대체: `ZAI_API_KEY`, 그 다음 `Z_AI_API_KEY`
