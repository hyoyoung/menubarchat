# Design

## Context

느림의 원인은 `TextField(axis: .vertical)`이 거대한 텍스트를 매 편집마다
재레이아웃하는 것이다. SwiftUI(macOS)는 TextField에 붙여넣기 가로채기를
제공하지 않고(`onPasteCommand`는 iOS 계열), NSTextView 교체는 변경이
크다. 제약: CLT 빌드, 무의존성, UI 상태는 ChatModel의 `@Published`.

## Goals / Non-Goals

**Goals:**

- 거대한 붙여넣기의 레이아웃 비용 제거(입력란에 넣지 않는다)
- 비텍스트 붙여넣기를 안내와 함께 명시적으로 거부

**Non-Goals:**

- 이미지 첨부(비전 모델) 기능, NSTextView 기반 입력란 교체,
  붙여넣기 히스토리

## Decisions

### D1: ⌘V 로컬 이벤트 모니터로 삽입 전 가로채기

`NSEvent.addLocalMonitorForEvents(matching: .keyDown)`에서 ⌘V를 감지해
① 채팅 패널이 키윈도우고 ② 설정 섹션이 닫혀 있을 때만 판정한다.
pasteboard에 문자열이 없으면 안내 후 이벤트 삼킴, 문자열이
`PromptComposer.isLongPaste`(10줄 초과, 기존 스펙과 동일 기준)면
스테이징 후 삼킴, 그 외는 이벤트 통과(일반 붙여넣기). 삽입 전에
판정하므로 붙여넣는 순간의 비용도 발생하지 않는다. 모니터는
AppDelegate가 앱 수명 동안 소유한다.

### D2: 스테이징 상태 — `@Published var stagedPaste: String?`

단일 값이며 칩으로 표시한다(대기 메시지 패널과 같은 자리, 같은 스타일).
칩 조작: 휴지통=해제, 연필=초안 되돌리기(편집을 원하면 스스로 렉을
감수하는 선택). 전송 시 `send()`가 `stagedPaste`를 본문으로 삼고
비어 있지 않은 초안을 개행으로 앞에 결합한다 — `sendNow`의
`isLongPaste` 판정이 자동으로 `ID<n>p`를 부여하므로 기존 긴 붙여넣기
절카 흐름이 그대로 재사용된다.

### D3: 거부 안내 — `@Published var pasteNotice: String?`

입력란 위 캡션으로 3초 후 자동 소멸(Task.sleep). 대화 오염(에러
말풍선) 없이 즉각적인 피드백만 준다.

## Risks / Trade-offs

- [모니터가 ⌘V를 과하게 삼킴] → 패널 키윈도우 + 설정 닫힘 조건으로
  범위를 좁힌다. 설정 필드·다른 앱은 영향 없음(로컬 모니터는 이 앱
  이벤트만).
- [스테이징된 텍스트와 초안 결합 순서 혼동] → 규칙을 단순 고정:
  "초안 + 개행 + 스테이징 본문". 칩·초안에 각각 무엇이 실리는지 화면에
  보이므로 예측 가능하다.
- [⌘V 외 붙여넣기 경로(메뉴 Edit > Paste)] → 설치된 Edit 메뉴 경로는
  모니터를 지나지 않는다. 드문 경로이며 그 경우 종전 동작(텍스트
  삽입)이므로 실패가 아니라 완화로 둔다.

## Migration Plan

1. ChatModel 상태·전송 결합 → 2. 모니터 → 3. 칩·안내 UI →
   `swift build` → selftest 회귀 → `./openspec-all-build.sh` → 수동 확인
