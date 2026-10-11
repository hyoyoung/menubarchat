# Proposal

## Why

프롬프트 조립(`apiContent`와 헬퍼)은 ID<n> 스텁 대체·재포함·지시문 부착이
얽힌 ChatModel에 남은 가장 복잡한 로직인데, 테스트 타깃이 없어 수동
검증에만 의존한다.

## What Changes

- 프롬프트 조립을 ChatModel의 private 인스턴스 메서드에서 순수 헬퍼
  `PromptComposer`(caseless enum, static 함수 — messages와 urlHandling을
  파라미터로 받음)로 추출한다. 동작 변화 없음.
- SwiftPM 테스트 타깃을 추가하고 스텁 대체·전문 포함·재포함·중복 제거·
  지시문 부착을 XCTest로 검증한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

(없음 — 동작 변화가 없는 리팩터링+테스트라 `.openspec.yaml`에
`skip_specs: true` 설정)

## Impact

- `Sources/MenuBarChat/PromptComposer.swift` 신규 (조립 로직 이동)
- `Sources/MenuBarChat/ChatModel.swift` — 조립 호출부 교체, 축소
- `Package.swift` — testTarget 추가
- `Tests/MenuBarChatTests/PromptComposerTests.swift` 신규
- 요청 본문·스펙 불변. 검증은 `swift test`와 `./openspec-all-build.sh`.
