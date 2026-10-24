# Proposal

## Why

다이제스트 항목의 굵기가 들쭉날쭉하다(모델이 매번 제멋대로 꾸밈). 기사
제목에 링크를 달아 클릭·복사하고 싶지만 모델이 기사별 URL을 갖고 있지
않다 — fetch가 본문 텍스트만 뽑아 앵커 href가 소실되기 때문.

## What Changes

- 추출: PageFetcher가 앵커 (제목, URL) 쌍을 수집한다 — 정적 HTML 정규식과
  렌더 폴백의 DOM 앵커 배열 모두에서. http(s)만, 상대 URL은 페이지 URL로
  해석, `#`·같은 페이지 링크 제외, href 기준 중복 제거, 페이지당 상한
  40개. FetchedPage.links로 보관.
- 주입: 명령 메시지 첨부에 페이지 발췌 뒤 "Links:" 목록을 함께 실는다.
- 서식: 내장 news 프롬프트에 항목 형식 지정 — "**[제목](URL)** — 한 줄
  요약", "Links 목록의 URL만 사용하고 확실하지 않으면 링크 없이"(URL
  지어내기 방지 안전 밸브). 제목 굵게·본문 보통 일관성도 이 지시로
  확립.
- 렌더: SelectableTextView가 링크 속성을 살려 클릭 시 브라우저로 연다
  (드래그 복사는 기존 선택 기능).

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 웹 페이지 읽기(앵커 수집·Links 첨부)·인라인
  마크다운 표시(링크 클릭)
- `settings`: 영속화 — 내장 news 프롬프트 서식 지시

## Impact

- `Sources/MenuBarChat/PageFetcher.swift` — 앵커 수집·렌더 앵커
- `Sources/MenuBarChat/PromptComposer.swift` — Links 첨부
- `Sources/MenuBarChat/SettingsStore.swift` — 프롬프트 서식
- SelfTest — 앵커 필터 순수 함수
