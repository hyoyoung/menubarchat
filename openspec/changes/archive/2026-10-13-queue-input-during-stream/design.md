# Design

## Context

현재 `send()`는 `isStreaming`이면 입력을 무시한다. 스트리밍 수명은
`streamTask`가 관리하며 `send()`의 Task 끝에서 `isStreaming = false`가
된다. SwiftUI 매크로 제약으로 UI 상태는 ChatModel의 `@Published`에 둔다.

## Goals / Non-Goals

**Goals:**

- 스트리밍 중 입력을 단일 슬롯 대기열로 받아 스트림 종료 직후 자동 전송

**Non-Goals:**

- 대기 취소 UI, 복수 대기, 대기 메시지 편집

## Decisions

### D1: 단일 슬롯 — `@Published var queuedMessage: String?`

Enter 시점에 검증해 저장하고 초안을 비운다. 이미 대기 중이면 무시한다
(초안 유지 — 텍스트 손실 없음). 상태가 하나뿐이라 배열이나 타입
도입은 과하다.

### D2: 드레인은 `send()`의 Task 끝에서

```
send() Task:
  fetchPages → stream → isStreaming=false
  → if let queued { queuedMessage=nil; sendNow(queued) }
```

완료·중단 모두 이 경로를 지나므로 `stop()`은 큐를 건드리지 않는다
(자의적 드롭 방지). 재귀 폭발 위험은 없다 — 드레인은 큐를 해제한
뒤 호출되고, 두 번째 스트리밍 중 Enter는 다시 최대 1개만 쌓인다.

### D3: 구조 — `send()`를 검증 래퍼 + `sendNow(_:)`로 분리

`send()`는 초안 검증·빈 키 가드·스트리밍 분기(대기)를 담당하고
실제 전송 동작은 `sendNow(prompt)`로 뽑는다. 드레인은 `sendNow`만
호출하므로 초안·대기 상태를 다시 검증하지 않는다.

### D4: 표시 — 대기 패널 (참고 UI 반영)

입력란 위 카드: 헤더 행("대기 메시지 1개" + 파란 점 스타일의 대기
표시 + "모두 지우기" ⌥⌘⌫), 항목 행(상태 점, 본문, 휴지통=삭제,
연필=초안 되돌리기, "지금 보내기" ↵). 최대 1개라 펼침(셰브론)은
생략한다. 연필은 대기 텍스트를 초안으로 옮기고(기존 초안이 있으면
개행으로 이어 붙임) 큐를 해제한다. "지금 보내기"는 `stop()`만 호출한다
— D2 드레인이 종료 직후 전송을 마친다. ⌥⌘⌫는 SwiftUI
`.keyboardShortcut(.delete, modifiers: [.option, .command])`로 건다.

## Risks / Trade-offs

- [대기 메시지가 즉시 확정되어 수정 불가] — 의도된 동작(초안을 비우고
  확정). 필요해지면 취소 UI를 별도 변경으로 추가.
- [stop 후 즉시 다음 스트림 시작] — 사용자가 stop을 눌렀어도 대기
  메시지는 전송된다. 예측 가능성(드롭 없음)을 우선한다. 불편이 확인되면
  stop 시 큐 캡션만 남기는 등 후속 조정.

## Migration Plan

1. ChatModel 상태·분리·드레인 구현 → `swift build`
2. ContentView 캡션 → `swift build` → `./openspec-all-build.sh` → 수동 확인
