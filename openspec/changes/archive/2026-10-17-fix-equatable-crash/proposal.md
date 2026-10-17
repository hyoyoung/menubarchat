# Proposal

## Why

`message-render-cache`가 도입한 `MessageView.==`이
`@EnvironmentObject`(chat)의 copiedMessageID·hoveredMessageID를 읽는데,
SwiftUI는 Equatable 비교를 environment가 주입되지 않은 갱신 파이프라인
단계에서 실행한다 — 비교가 일어나는 모든 상태 변경에서
`EnvironmentObject.error()` 치명 assertion으로 앱이 강제 종료된다
(크래시 로그 MenuBarChat-2026-10-17-165436.ips, thread 0에서 확인).

## What Changes

- `==`의 비교 입력을 stored property로만 구성한다: MessageView가
  `copiedMessageID`·`hoveredMessageID`를 일반 저장 프로퍼티로 받고, ==
  는 message + 이 값들을 비교한다 (environment 접근 제거).
- 표시 판정(체크마크·호버 공개)은 저장 값을 사용하고, 액션(복사·접기
  토글 등)만 `@EnvironmentObject`를 쓴다 — body 안의 environment
  접근은 안전하다.
- 렌더 스킵 최적화(`.equatable()`)는 그대로 유지된다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

(없음 — 동작 무변경 크래시 핫픽스라 `.openspec.yaml`에 `skip_specs:
true` 설정)

## Impact

- `Sources/MenuBarChat/ContentView.swift` — MessageView 저장 프로퍼티
  추가·== 교체·호출부 전달 (수 줄)
