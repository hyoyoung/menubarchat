# Design

## Context

실측: CNN HTML 4.8MB, 500k 절단이 style 블록 내부에 걸려 닫는 태그
상실 → CSS가 본문으로 생존. 정적 DOM 텍스트는 광고 설문 크롬 9,860자뿐.
현행 폴백 NSAttributedString(html:)은 JS 미실행이라 React 앱 본문
불가. 무의존성 제약 안에서 JS 실행 = 시스템 WebKit(WKWebView).

## Goals / Non-Goals

**Goals:**

- 절단이 블록 제거를 무력화하지 않게 순서 고정
- 품질 미달 페이지의 실제 JS 렌더링 추출

**Non-Goals:**

- 사이트별 파서, 광고 차단, 렌더 스크린샷, 쿠키/동의 자동 처리

## Decisions

### D1: 2단계 strip — 블록 제거(전체) → 절단 → 태그 스캔

`stripTags`를 `strippedText(fromHTML:)`로 재구성: ① 전체 HTML에서
script/style/head 블록 제거 ② 남은 텍스트 prefix(500k) ③ 태그 스캔·
엔티티 복원. 내부 노출로 SelfTest가 절단 불변식(거대 style 블록이
경계 너머까지 이어져도 제거됨)을 고정한다.

### D2: 폴백 렌더러 — WKWebView innerText (캡 3초)

`runImporter` 클로저를 WKWebView 기반으로 교체: 페이지 로드(load),
완료 또는 3초 경쟁 후 `document.body.innerText` evaluateJavaScript로
추출. 렌더러는 백그라운드 생성·MainActor 호출은 비동기 hop으로 격리,
기존 타임아웃 경쟁 구조(withTaskGroup)는 그대로 재사용. NSAttributedString
경로는 제거(단일 경로 유지).

### D3: 채택 기준 무변경

렌더 결과도 기존 품질 기준(실내용 ≥200 & 비율 ≥50%) 적용, 미달 시
정리된 원본 반환(현행 규칙 유지).

## Risks / Trade-offs

- [WKWebView 첫 생성 비용] 커맨드 다중 fetch에서 최초 1회 수백 ms —
  2창 병렬이라 허용 범위.
- [동의 벽 페이지] 렌더해도 콘텐츠 없으면 품질 미달 → 정리된 원본 —
  현행과 동일한 우아한 열화.

## Migration Plan

1. 2단계 strip + 절단 불변식 SelfTest → 2. WKWebView 렌더러 교체 →
build/selftest/all-build → 수동(/news CNN 헤드라인 확인)
