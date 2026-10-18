# Design

## Context

실측(스크립트 재현): news.naver.com 정적 제거 텍스트 93k 자지만 시작이
내비 숩, edition.cnn.com는 4.8MB React 앱이라 정적 텍스트가 광고 설문
크롬. 현행 `isSufficientText`(≥200자)가 이들을 통과시켜 WebKit 렌더링
추출(firstExtraction, 2초 경쟁)로 못 넘어가게 막는다. 정적 사이트(HN·BBC)는
현행 경로가 이미 양호.

## Goals / Non-Goals

**Goals:**

- 내비/크롬 숩은 렌더링 추출로 폴백, 정적 풍부 사이트는 빠른 경로 유지

**Non-Goals:**

- 사이트별 특화 파서, readibility 라이브러리, 렌더링 대기의 무한 증가

## Decisions

### D1: 품질 판정 — 실내용 기준의 순수 함수

`isSufficientText`를 교체: 텍스트를 공백 접기 + 한 글자도 남지 않는
기호/공백 조각 제거한 뒤, ①실내용 글자 수 ≥ 200 ②실내용이 전체의
50% 이상 — 두 조건 모두 충족 시 충분. 순수 함수이라 SelfTest로 고정
(내비 숩: 파이프/공백 대량 → ②미달, 실제 글: 통과). 첫 줄 미리보기·
발췌에도 이 정리를 적용해 노이즈 축소.

### D2: 폴백 흐름 — 기존 경쟁 구조 재사용

stripped가 품질 미달 → 기존 firstExtraction 렌더러 호출(타임아웃 경쟁
유지), 렌더 결과도 같은 품질 기준 적용(미달이면 원본 stripped라도
정리된 형태로 반환 — 실패 오류보다 나음). 경로 변경 없이 판정만 교체.

### D3: 렌더 대기 캡 — 실측 후 결정

현행 2초. CNN 수화가 2초 안에 헤드라인을 그리는지 수동 검증(3.2)에서
확인하고, 부족하면 3초로 한 단계만 올린다(무한 증가 금지).

## Risks / Trade-offs

- [정적 풍부 사이트 오분류] ②비율 조건이 보수적(50%)이라 HN·BBC 수준은
  통과 — SelfTest로 회귀 고정.
- [렌더러 실패 시 품질 낮은 원본 반환] — 오류 표시보다 낫고, 모델이
  무시 가능한 수준.

## Migration Plan

1. 품질 판정 함수 + SelfTest → 2. isSufficientText 교체·폴백 확인 →
build/selftest/all-build → 수동(/news에서 네이버·CNN 헤드라인 수집 확인,
렌더 캡 필요시 3초 조정)
