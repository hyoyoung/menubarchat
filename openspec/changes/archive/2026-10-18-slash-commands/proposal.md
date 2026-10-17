# Proposal

## Why

자주 쓰는 프롬프트(뉴스 다이제스트 등)를 매번 붙여넣는 대신, 입력창에서
`/명령` 한 번으로 전개하고 싶다. 다른 도구의 슬래시 명령 UX와 같은 패턴.

## What Changes

- 설정에 커스텀 명령 목록(이름 → 프롬프트 템플릿) 편집기를 추가한다.
- 입력창 초안이 `/`로 시작하면 일치하는 명령을 입력창 위 드롭다운으로
  표시한다. 선택하면 `/명령` 부분이 프롬프트로 전개되어 초안에 들어가고
  (검토·수정 후 전송), `/명령` + Enter 직접 전송도 전개 후 전송한다.
- 전개는 단순 텍스트 치환 — 이후 흐름(URL fetch, 이미지, 스트리밍)은
  일반 메시지와 동일하게 동작한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 커스텀 슬래시 명령 요구사항 추가
- `settings`: 설정 필드·영속화에 명령 목록 포함

## Impact

- `Sources/MenuBarChat/SettingsStore.swift` — 명령 저장소
- `Sources/MenuBarChat/ChatModel.swift` — 전개 헬퍼(순수 함수)
- `Sources/MenuBarChat/ContentView.swift` — 드롭다운 오버레이 + 설정 편집기
- SelfTest — 전개 규칙 회귀
