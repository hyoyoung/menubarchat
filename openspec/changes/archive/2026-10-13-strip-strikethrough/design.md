# Design

## Context

실측(strikecheck 스크립트): `AttributedString(markdown:)` +
`inlineOnlyPreservingWhitespace`는 GFM `~~...~~`를
`InlinePresentationIntent.strikethrough`로 파싸하며, 짝이 줄바꿈을
건너 매칭된다("a ~~b\nc~~ d"에서 "b\nc" 런 전체에 strike). SwiftUI
Text가 이를 취소선으로 그린다. `~~~` 코드 펜스 자체는 짝을 이루지
않았다(가설 처음과 달리).

## Goals / Non-Goals

**Goals:**

- 어떤 입력에서도 취소선이 그어지지 않게 (스펙 계약대로)

**Non-Goals:**

- 취소선을 "제대로" 렌더링하는 것(계약에 없음), 블록 마크다운 지원

## Decisions

### D1: 파싱 후 인텐트 제거 — 코드 범위 무손상

파싱 후 각 런에서 `.strikethrough`만 빼낸다:

```swift
for run in attr.runs where run.inlinePresentationIntent?.contains(.strikethrough) == true {
    attr[run.range].inlinePresentationIntent = intent.subtracting(.strikethrough)
}
```

대안인 파싱 전 `~~` 이스케이프는 코드 범위(`` `...` ``) 안에서
백슬래시가 문자로 남아 본문을 오염시킨다. 실측 3케이스에서 제거 후
취소선 소거·굵게 유지·본문 무손상을 확인했다.

### D2: SelfTest로 회귀 고정

`MessageView.markdown`은 Foundation 타입만 쓰는 static 함수라 SelfTest에서
직접 호출 가능하다. 런의 인텐트를 검사해 (1) 줄바꿈 건너 `~~` 쌍에
strike 없음, (2) `**굵게**`는 유지를 단언한다.

## Risks / Trade-offs

- [모델이 진짜 취소선을 의도한 경우] 계약 밖 동작이므로 기호 원문
  노출이 정당하다. 필요해지면 별도 변경으로 계약에 추가.

## Migration Plan

1. markdown()에 제거 루프 → 2. SelfTest 2건 → `swift build` →
   selftest → `./openspec-all-build.sh` → 수동 확인
