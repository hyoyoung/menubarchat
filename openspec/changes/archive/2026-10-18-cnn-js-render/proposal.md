# Proposal

## Why

CNN이 계속 "스타일 코드만 반환"된다. 실측으로 원인 둘: ① `plainText`가
500k 자 절단을 `<style>` 블록 제거 **전**에 해서, 4.8MB CNN HTML의 절단
지점이 거대 style 블록 내부에 걸리면 닫는 태그가 사라져 CSS 전체가
"본문"으로 생존한다(CSS는 글자라 품질 기준도 통과). ② 폴백 렌더러가
NSAttributedString(html:) — 파서일 뿐 JS를 실행하지 않아 React 앱
(CNN)의 헤드라인을 얻지 못한다(정적 DOM은 광고 설문 크롬뿐, 실측 9,860자).

## What Changes

- 변환 순서 교체: `<script>/<style>/<head>` 블록 제거를 전체 HTML에
  적용한 뒤 남은 텍스트만 500k 절단 — 절단이 블록 경계를 깨뜨릴 수
  없게 만든다.
- 품질 미달 폴백을 JS 실행 렌더링(WKWebView, 3초 캡)으로 교체: 페이지를
  실제 로드·렌더하고 `body.innerText`를 추출한다. NSAttributedString
  폴백은 제거한다.
- 추출 결과는 기존 품질 기준(실내용 ≥200자 & 비율 ≥50%)을 동일하게
  통과해야 채택된다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 웹 페이지 읽기 — 렌더링 추출의 JS 실행 명시

## Impact

- `Sources/MenuBarChat/PageFetcher.swift` — 2단계 strip + WKWebView
  렌더러
- SelfTest — 절단 불변식(거대 style 블록이 절단 경계 넘어도 제거)
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
