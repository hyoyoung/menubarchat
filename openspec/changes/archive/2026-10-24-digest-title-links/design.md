# Design

## Context

모델은 기사 URL을 모른다(추출이 텍스트만 뽑는다). 앵커를 수집해 주입하면
모델이 제목-URL을 잇고, 서식 지시로 굵기 일관성까지 확보한다.

## Goals / Non-Goals

**Goals:**

- 다이제스트 항목 = **[제목](URL)** — 요약 (클릭 가능, 굵기 일관)
- URL 지어내기 방지 (Links 목록 외 금지)

**Non-Goals:**

- 링크 미리보기 카드, 클립보드 복사 버튼(선택 복사로 충분)

## Decisions

### D1: 앵커 수집 — 정적 정규식 + 렌더 DOM 배열

정적 경로: 원본 HTML에서 `<a [^>]*href="([^"]+)"[^>]*>(.*?)</a>` 반복
매칭, 태그 제거해 제목 확보. 렌더 경로: WKWebView
`document.querySelectorAll('a[href]')` evaluateJavaScript로
[href, text] 배열 수집. 공통 필터 `filteredAnchors(raw:base:)` 순수
함수 — http(s) 절대화(base URL로 해석), 프래그먼트·javascript: 제외,
href 중복 제거, 제목 trim·빈 제목 제외, 상한 40. SelfTest 고정.

### D2: 첨부 — 발췌 뒤 "Links:" 블록

apiContent의 명령 다중 페이지 경로에서 발췌 뒤
"\nLinks:\n- <제목> | <URL>" 줄들(페이지당). 일반 메시지 단일 페이지는
링크 없음(기존 전문 방식 유지 — 맥락상 불필요).

### D3: 서식 지시 — 프롬프트 1문장

"Format each entry as: **[Title](URL)** — summary; when the URL is
uncertain, use *Title* — summary instead (italic, no link). Use only
URLs from the Links lists." 링크 없는 항목은 기울임으로 구분해 굵은
제목(=클릭 가능)과 시각 분리.

### D4: 렌더 — NSTextView 기본 링크 동작 + 평범한 모양

AttributedString 마크다운 링크가 NSAttributedString 변환에서
.link로 유지되고, 편집 불가 NSTextView는 링크 클릭 시 기본 브라우저로
연다. 전경색은 labelColor로, 밑줄은 제거(.link 범위에
foregroundColor·underlineStyle [:] 덮어쓰기) — 링크가 일반 텍스트와
같은 모양이 된다(굵기·기울임이 유일한 시각 단서).

## Risks / Trade-offs

- [링크-제목 오탐] 모델이 잘못 이으면 잘못된 클릭 — "if unsure, omit"으로
  완화, 사용자 눈으로 확인 가능(링크 텍스트=제목).
- [토큰 증가] 페이지당 40줄 — 발췌 대비 미미.

## Migration Plan

1. filteredAnchors + 정적/렌더 수집 + SelfTest → 2. Links 첨부 →
3. 프롬프트 서식 → build/selftest/all-build → 수동(링크 클릭·굵기 일관·
오탐률 확인)
