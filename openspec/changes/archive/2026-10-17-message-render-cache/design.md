# Design

## Context

성능 병목 실측: 상태 변경(델타·스크롤·패널 토글)마다 보이는
MessageView 전체의 body 재실행 → Self.markdown(text) 파싱(수십 ms/장문)
+ NSImage(data:) 디코드가 매번 반복. Message는 이미 Equatable이므로
스킵 판정 재료가 있다.

## Goals / Non-Goals

**Goals:**

- 스크롤·패널 토글·스트리밍 중 프레임 비용을 마지막 메시지 1개 수준으로

**Non-Goals:**

- 표시 변경, 가상화 구조 교체, reasoning 렌더 최적화(plain text라 무관)

## Decisions

### D1: `.equatable()` — 변화 없는 메시지 body 스킵

MessageView를 Equatable 채택(메시지 비교)하고 사용부에
`.equatable()`. 델타가 마지막 메시지만 바꾸므로 나머지는 body 미실행.

### D2: Message 캐시 필드 + 커스텀 ==

`var cachedMarkdown: AttributedString?`, `var cachedImage: NSImage?` —
둘 다 Equatable 합성 불가(NSImage)라 Message에 커스텀 == 작성(의미
필드만 비교, 캐시 제외). 캐시는 렌더 자산일 뿐 동기화 대상이 아니다.

### D3: 캐시 시점 — 스트림 종료 시 1회

스트리밍 중 마지막 메시지는 라이브 파싱 유지(스타일 실시간 반영 유지,
대상 1개라 저렴). stream()의 for-await 종료 후 마지막 어시스턴트
메시지의 cachedMarkdown을 확정 저장. 썸네일은 첫 접근 시
lazy 디코드…가 아니라 sendNow에서 이미지 부착 시 1회 디코드 저장.

## Risks / Trade-offs

- [캐시 무효화 누락] — ==가 캐시 제외 의미 필드만 비교하므로 텍스트가
  바뀌면 body 재실행 → 라이브 파싱으로 자가 수복. 잘못된 캐시가
  남을 경로가 없다.

## Migration Plan

1. Message 캐시·커스텀 == + sendNow/streamEnd 캐시 확정 → 2.
MessageView Equatable·캐시 사용 → build/selftest/all-build → 수동:
긴 대화 스크롤·토글 체감, markdown·썸네일 표시 무변경
