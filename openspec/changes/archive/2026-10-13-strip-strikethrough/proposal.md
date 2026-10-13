# Proposal

## Why

인라인 마크다운 렌더러가 GFM 취소선(`~~...~~`)도 파싱하는데, 짝이
줄바꿈을 건너 매칭되어 모델 출력에 `~~`가 두 번 나오면 그 사이의 정상
줄들이 모두 취소선으로 렌더링된다(실측 재현). 스펙 "인라인 마크다운
표시"는 굵게·기울임·코드 범위·링크만 약속했고 취소선은 계약에 없다.

## What Changes

- `MessageView.markdown`이 파싱 후 각 런의 `inlinePresentationIntent`에서
  `.strikethrough`만 제거한다. 본문·굵게·기울임·코드 범위는 무손상
  (실측 확인).
- SelfTest에 취소선 제거 회귀 테스트를 추가한다.
- 스펙에 취소선은 스타일 없이 원문으로 둔다는 명시를 추가한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 인라인 마크다운 표시 — 취소선 미렌더링 명시

## Impact

- `Sources/MenuBarChat/ContentView.swift` — markdown()에 인텐트 제거
  루프 (수 줄)
- `Sources/MenuBarChat/SelfTest.swift` — 회귀 테스트 2건
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
