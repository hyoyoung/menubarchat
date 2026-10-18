# Proposal

## Why

기본 명령(news)이 UserDefaults에 한 번 심기면 앱이 업데이트돼도 저장된
구버전 프롬프트가 남아 시드 개선이 반영되지 않는다(실제 두 차례 발생 —
`defaults delete`로 수동 복구). 기본 명령은 앱 버전을 따라 항상 최신이어야
한다.

## What Changes

- 기본 명령을 코드 상수로만 제공한다(UserDefaults 미저장) — 매 실행이
  최신이므로 업데이트 즉시 반영되고 저장본이 존재하지 않는다.
- 저장소(`commands` 키)는 사용자가 만든 명령만 담는다(추가·편집·삭제
  자유, 재시작 유지).
- 명령 조회는 기본 우선: 같은 이름의 사용자 명령이 있어도 기본이
  이긴다(구버전 저장본이 새 기본을 덮치는 일을 원천 차단).
- 편집기: 기본 명령은 읽기 전용 표시(기본 배지), 사용자 명령만 편집.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `settings`: 설정 필드·영속화 — 기본/사용자 명령 분리
- `chat-conversation`: 커스텀 슬래시 명령 — 명령 목록 구성과 조회 순서

## Impact

- `Sources/MenuBarChat/SettingsStore.swift` — builtinCommands 상수,
  availableCommands 계산, commands는 사용자 명령만
- `Sources/MenuBarChat/ChatModel.swift`·`ContentView.swift` — 조회·
  편집기 호출부
- SelfTest — 병합·우선순위 회귀
