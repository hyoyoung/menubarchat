# Design

## Context

`apiContent(for:isLast:)`는 messages 전체와 `settings.urlHandling`에 결합된
ChatModel private 메서드다. 이전 변경(아카이브 `2026-10-12-split-chatmodel-
along-spec-seams`)은 테스트가 없어 이 추출을 보류했었다. 제약: Command
Line Tools만으로 빌드, 서드파티 의존성 없음.

## Goals / Non-Goals

**Goals:**

- 프롬프트 조립을 순수 함수로 만들어 XCTest로 검증
- 요청 본문 불변

**Non-Goals:**

- ChatModel의 다른 부분(SSE, 페이지 fetch) 테스트
- 프롬프트 로직 자체의 변경

## Decisions

### D1: PromptComposer는 값만 받는 static 함수

`apiContent(messages:urlHandling:for:isLast:)` 형태 — ObservableObject·
MainActor 의존을 제거한다. 대안(ChatModel 메서드를 internal로 공개)은
상태 결합이 남아 테스트가 ChatModel 인스턴스와 설정 저장을 요구한다.

### D2: 셀프테스트 모드로 구현

이 환경의 CLT(Swift 6.4, SDK 27)에는 import 가능한 테스트 러너가 없다
(XCTest·Testing swiftmodule 부재, 실행→실행 의존은 심볼 미노출로 기각).
검증은 앱 실행 타깃 안의 `SelfTest`(손제 유닛테스트 하네스)로 하고
`swift run MenuBarChat --selftest`가 exit 코드로 결과를 보고한다.
목업 기반 ChatModel 오케스트레이션 테스트(LLMClient 프로토콜 주입)는
별도 변경으로 연기한다.

## Risks / Trade-offs

- [이동 중 미세한 동작 변화] → 이동은 복사 후 참조만 교체하고, 테스트가
  현행 동작(스텁 형식 문자열 포함)을 고정해 회귀를 즉시 포착한다.

## Migration Plan

1. PromptComposer.swift로 로직 이동, ChatModel 호출부 교체
2. Package.swift testTarget 추가, 테스트 작성
3. `swift test` → `./openspec-all-build.sh`
