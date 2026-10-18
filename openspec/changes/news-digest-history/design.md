# Design

## Context

중복 제거의 판단은 모델이(의미 인식), 앱은 저장·주입만. 데이터는 하루
수 KB 텍스트라 쿼리가 필요 없어 SQLite 대신 JSON 파일. 사용자 지정:
24시간 경과 항목은 재사용 시점에 제거.

## Goals / Non-Goals

**Goals:**

- 직전 다이제스트 기억 → 반복 기사 제거
- 만료·링 규칙의 결정적 동작 (SelfTest 고정)

**Non-Goals:**

- SQLite/기사 단위 쿼리, UI에서 이력 열람, 만료 기간 설정화

## Decisions

### D1: 저장소 — NewsHistory (순수 로직 + 파일 I/O 분리)

항목: `Codable { date: Date, text: String }`. 파일:
`~/Library/Application Support/MenuBarChat/news-history.json`(없으면
빈 링 시작). 로드 시 24시간 초과 항목 제거 후, 제거가 일어났으면 파일
재작성(사용자 규칙). append는 링 앞에 추가해 최근 5개 유지.
핵심 함수 `trimmed(entries:now:) -> [Entry]`(만료·캡)을 순수 함수로
분리해 SelfTest로 고정(24h 경과 제거·5개 캡·순서 유지).

### D2: 주입 — {previous} 치환 ({language} 메커니즘 재사용)

전개 시 `SlashCommands.applyingLanguage`와 같은 자리에서 `{previous}`
치환: 24h 내 직전 최대 2개를 "— <다이제스트>" 구분자로 연결, 없으면
"none". 내장 프롬프트에 "Below are previous digests; do not repeat
stories already covered there: {previous}" 문장 추가.

### D3: 저장 시점 — 스트림 종료 훅

stream() 정상 종료 시 마지막 사용자 메시지가 `viaCommand &&
commandName == "news"`면 마지막 어시스턴트 답변을 append. 오류 종료는
저장하지 않는다(불완전 다이제스트 오염 방지).

## Risks / Trade-offs

- [이전 다이제스트 토큰] 직전 2개 ≈ 2-4k 토큰 — 중복 제거 이득이 큼.
- [파일 손상] 디코드 실패 시 빈 링으로 시작(설정 스펙의 우아한 열화와
  동일한 태도).

## Migration Plan

1. NewsHistory(순수 함수 + I/O) + SelfTest → 2. {previous} 치환·프롬프트
문장 → 3. 종료 훅 저장 → build/selftest/all-build → 수동(두 번 연속
/news로 반복 제거 확인)
