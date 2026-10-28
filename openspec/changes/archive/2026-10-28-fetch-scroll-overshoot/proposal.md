# Proposal

## Why

URL 입력 후 페치 중 미리보기 카드가 연달아 삽입되며 매 변경마다
scrollTo가 같은 프레임에 실행된다 — 자라는 중인 콘텐츠 높이로 오프셋을
계산해 뷰포트가 콘텐츠 끝을 지나감(백지 + 러버밴드, 실사용 관찰).

## What Changes

- scrollToBottom 내부의 scrollTo를 다음 런루프(레이아웃 커밋 후)로
  지연한다.
- ScrollView에 `.scrollBounceBehavior(.basedOnSize)`를 붙인다 — 콘텐츠가
  뷰포트보다 짧을 때 바운스를 끈다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

(없음 — 스크롤 신뢰성 수정, skip_specs)

## Impact

- `Sources/MenuBarChat/ContentView.swift` — scrollToBottom 지연·bounce 옵션
