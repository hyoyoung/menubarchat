# Design

## Context

현재 plainText는 WebKit 임포터(utility) vs 5초 타이머 경쟁 후, 타이머
승리 시 stripTags 폴백. 실측적으로 임포터는 500KB HTML에서 수 초,
타이머가 이기는 경우가 대부분 → 5초 고정 대기. Task.cancel은 동기
ObjC 호출을 중단하지 못해 배경 CPU 낭비도 있다.

## Goals / Non-Goals

**Goals:**

- 일반 페이지의 본문 추출을 1초 이내로
- JS 셸 페이지에서의 품질 보험 유지

**Non-Goals:**

- 본문 추출 품질 기준 변경, 네트워크 계층(DNS/TLS) 최적화,
  WebKit 임포터 완전 제거(B안)

## Decisions

### D1: strip 우선, 충분하면 즉시 반환

```
plainText(html):
  stripped = stripTags(html)          // 사실상 즉시
  if stripped.count >= 200: return stripped
  // 빈약한 경우만 무거운 경로
  return await webKitOrFallback(html, cap: 2s)
```

기준 200자: 요약에 쓸모있는 최소 본문. JS 렌더링 셸은 대개 이하.

### D2: 임포터 대기 캡 5초 → 2초, 우선순위 상향

기다리는 유일한 경로가 됐으므로 `.userInitiated`. 캡 2초 — 빈약
페이지에서 WebKit이 실제로 값을 내는 경우는 대부분 2초 내다.

### D3: SelfTest로 회귀 고정

strip 우선 판정(`isSufficientText`)을 순수 static으로 분리해 테스트:
충분한 strip → 임포터 미호출(호출 여부는 주입된 클로저로 검증), 빈약 →
임포터 결과 채택, 임포터 타임아웃 → strip 반환.

## Risks / Trade-offs

- [일부 페이지에서 WebKit 품질을 놓침] → 충분한 strip(≥200자)만 즉시
  경로이므로 실제 손실은 드물다. 200자는 사용 중 조정 가능한 상수.
- [2초 캡에서 임포터가 못 끝냄] → 종전보다 빠르게 폴백하므로 엄격한
  개선. 품질 불만 시 캡만 올리면 된다.

## Migration Plan

1. 판정 분리 + 재구성 → 2. SelfTest → `swift build` → selftest →
   `./openspec-all-build.sh` → 수동 확인(일반 사이트 붙여넣기 체감)
