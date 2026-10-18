# Proposal

## Why

연속 `/news` 실행은 같은 기사가大量으로 겹친다. 직전 다이제스트를 기억해
반복을 제거한다. 중복 "판단"은 문자열 비교가 아니라 모델이 하게 하고
앱은 "저장·주입"만 담당한다.

## What Changes

- 뉴스 명령의 응답 완료 시 그 다이제스트를 JSON 링(항목 = 타임스탬프 +
  텍스트, 최근 5개)에 저장한다. 저장소는 Application Support의 파일
  하나 — SQLite는 이 규모(하루 수 KB, 쿼리 없음)에 과하다.
- **만료: 재사용 시점에 24시간보다 오래된 항목은 제거하고 파일을
  다시 쓴다** (하루 전 다이제스트는 뉴스 사이클이 지났으므로 중복
  비교 대상이 아니라는 사용자 지정 규칙).
- 전개 프롬프트에 `{previous}` 플레이스홀더를 추가하고, 24시간 내 직전
  최대 2개 다이제스트로 치환한다(없으면 "none"). 프롬프트는 이전
  다이제스트에 이미 다룬 기사를 반복하지 않도록 지시한다.

## Capabilities

### New Capabilities

(없음 — 아래 요구사항은 기존 역량에 추가)

### Modified Capabilities

- `chat-conversation`: 뉴스 다이제스트 이력 요구사항 추가

## Impact

- `Sources/MenuBarChat/NewsHistory.swift` 신규(저장소: 로드·만료·append)
- `Sources/MenuBarChat/SettingsStore.swift` — 프롬프트에 {previous} 추가
- `Sources/MenuBarChat/ChatModel.swift` — 치환·응답 저장
- SelfTest — 만료·링 갱신 회귀
