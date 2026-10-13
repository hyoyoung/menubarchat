# Design

## Context

현재 `onChange(of: chat.messages)`가 무조건 `proxy.scrollTo(last)`를
호출한다. 제약: CLT 빌드라 뷰 상태(@State)를 못 쓰므로 팔로우 상태는
ChatModel의 `@Published`에 둔다. SwiftUI는 사용자 스크롤과 프로그램
스크롤을 구분해 주지 않는다 — 순수 Geometry 기반 판정은 "내용이 늘어나
순간적으로 맨아래가 아니게 됨"을 사용자 스크롤로 오인하는 경쟁이 있다.
이 앱은 이미 ⌘V 가로채기에 NSEvent 로컬 모니터 패턴이 있다.

## Goals / Non-Goals

**Goals:**

- 스트리밍 중 사용자 스크롤 위치 보존, 끊긴 경우 즉시 맨아래 복귀 수단

**Non-Goals:**

- 스크롤 위치의 영속화(재시작 복원), 가로 스크롤, 키보드 단축키

## Decisions

### D1: 팔로우 해제는 scrollWheel 모니터로만 — 경쟁 원천 차단

AppDelegate의 로컬 모니터에 `.scrollWheel`을 추가한다. 채팅 패널이
키윈도우일 때 "위로 스크롤" 입력이 오면 `chat.followsBottom = false`.
프로그램 자동 스크롤은 scrollWheel 이벤트를 만들지 않으므로 오탐이
원천적으로 없다. 방향 판정은
`event.scrollingDeltaY > 0 != event.isDirectionInvertedFromDevice`.

### D2: 재개는 하단 도달 감지 + 명시적 행위

- GeometryReader로 스크롤 콘텐츠 하단과의 거리가 임계값(예: 40pt)
  이하이면 `followsBottom = true`(점프 버튼 숨김).
- 점프 버튼: `proxy.scrollTo(last, anchor: .bottom)` + 즉시 true.
- 전송(`sendNow`) 시 true 재개 — 자기 메시지를 보게 된다.

### D3: 상태 배치 — ChatModel `@Published var followsBottom = true`

뷰에 상태를 둘 수 없는 제약 준수. 뷰는 읽기만 하고, 변경은 모니터·
지오메트리·전송 경로가 한다.

### D4: 점프 버튼 UI

ScrollView에 `.overlay(alignment: .bottom)`으로 28pt 원형
`arrow.down` 버튼, 반투명 배경, 하단 중앙. `!followsBottom && !messages
.isEmpty`일 때만 표시 — "스크롤이 멈춰 있을 때만" 요구와 일치.

## Risks / Trade-offs

- [scrollWheel 모니터가 설정 필드 스크롤도 삼킴] → 패널 키윈도우
  조건만으로 충분(설정 섹션 안의 스크롤도 "위로"면 팔로우 해제일 뿐
  이벤트를 삼키지 않는다 — 모니터는 관찰만 하고 이벤트를 반환).
- [맨아래 감지 임계값 미세 오차] → 40pt 여유로 트랙패드 관성 종점에서도
  재개로 인식. 부족하면 사용 중 조정.

## Migration Plan

1. ChatModel 상태 + 전송 재개 → 2. 모니터 → 3. 뷰(조건부 스크롤·
   지오메트리·버튼) → `swift build` → selftest 회귀 →
   `./openspec-all-build.sh` → 수동 확인
