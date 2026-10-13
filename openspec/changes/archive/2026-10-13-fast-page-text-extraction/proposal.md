# Proposal

## Why

웹 페이지 본문 추출이 보통 5초 이상 걸린다. 원인은 plainText의 경쟁
구조: 레거시 WebKit 임포터(NSAttributedString(html:), utility 우선순위)
를 5초 타이머와 겨루는데 임포터가 못 이기는 경우가 대부분이라 5초를
기다린 뒤 어차피 즉시 끝나는 stripTags 폴백을 쓰게 된다. 진 타이머 뒤에도
임포터는 Task.cancel로 멈추지 않아 CPU를 계속 태운다.

## What Changes

- 순서를 뒤집는다: stripTags를 먼저 돌려 결과가 충분하면(200자 이상)
  즉시 반환한다. 빈약한 결과(JS 셸 페이지)만 WebKit 임포터를 2초 캡으로
  기다리고, 그래도 없으면 stripTags 결과를 쓴다.
- 임포터 우선순위를 `.userInitiated`로 올린다(기다리는 유일한 경로이므로).
- 동작 변화는 없다 — 추출 품질 기준과 오류 문자열, 호출부는 그대로.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

(없음 — 본문 추출 방식은 구현 디테일. `.openspec.yaml`에 `skip_specs:
true` 설정)

## Impact

- `Sources/MenuBarChat/PageFetcher.swift` — `plainText(fromHTML:)` 재구성
  (수십 줄 내)
- SelfTest로 strip 우선 로직 회귀 고정
- YouTube 자막 경로는 이 함수를 사용하지 않아 무영향
