# Proposal

## Why

메뉴 막대 아이콘 클릭이 가끔 죽는다 — 패널이 `isVisible` && occlusion
`.visible`이지만 실제로는 다른 앱 뒤·다른 Space에 가려져 있으면 첫
클릭이 "숨김"으로 소비되어 화면에 아무 변화가 없다(긴 텍스트 붙여넣기
후 복사하러 앱을 오갈 때 재현, 실사용 관찰).

## What Changes

- 토글의 숨김 조건을 `isVisible && occlusion == .visible`에서
  `isVisible && isKeyWindow`로 바꾼다 — 사용자가 패널을 조작 중(키)일
  때만 클릭으로 숨기고, 키가 아니면(가려짐·비활성·다른 Space) 클릭은
  항상 재표시로 동작한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

(없음 — 동작 신뢰성 수정, skip_specs)

## Impact

- `Sources/MenuBarChat/MenuBarChatApp.swift` — 토글 조건 한 줄
