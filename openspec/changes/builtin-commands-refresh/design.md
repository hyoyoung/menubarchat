# Design

## Context

"한 번만 심기" 시딩이 저장본을 만들어 앱 업데이트와 프롬프트 개선을
분리시켰다(두 차례 수동 defaults delete 발생). 기본 명령의 진실 공급원을
코드로 옮기면 버전 관리(git)가 곧 기본 명령 버전이 된다.

## Goals / Non-Goals

**Goals:**

- 기본 명령 = 항상 최신(코드), 사용자 명령 = 사용자 소유(저장소)
- 기존 저장 키(`commands`)의 구버전 시드가 새 기본을 덮치지 않게

**Non-Goals:**

- 기본 명령의 사용자 재정의, 기본 명령 끄기, 원격 명령 배포

## Decisions

### D1: 기본 우선 조회 — 마이그레이션 불필요

`availableCommands = builtinCommands + commands.filter { 이름이 기본과 안 겹침 }`.
사용자가 아닌 "기본"이 우선하므로, 과거에 저장된 구버전 `news`는 자연히
그림자처럼 무시된다 — 저장 키 이전/정리 마이그레이션 코드가 아예 필요
없다(저장본은 사용자 명령으로 간주되어 이름 충돌로 가려짐).

### D2: builtinCommands는 nonisolated 정적 상수 (구 defaultCommands 계승)

이름만 개명하고 프롬프트 내용은 현행 유지 — 대기 중인
news-prompt-stem-scope 변경이 이 상수를 수정한다(순서 무관).

### D3: 편집기 2분할 — 기본(읽기 전용 배지) / 사용자(편집)

기본 행은 이름+프롬프트 표시만. 사용자 목록은 기존 편집기 그대로.
호출부(ChatModel.send·applyCommand·Tab·드롭다운)는 전부
`settings.availableCommands`로 교체.

### D4: SelfTest — 병합·우선순위

사용자 명령이 기본과 같은 이름이면 가려짐, 다른 이름이면 병합,
기본은 단독 존재. 기존 시드 회귀(영어·{language})는 builtin 대상으로
이관.

## Risks / Trade-offs

- [기본을 살짝 고쳐 쓰던 사용자] 다른 이름의 사용자 명령으로 재작성
  필요 — 본 앱 사용자(1인)는 기본 최신화 편이 훨씬 큰 가치.

## Migration Plan

1. builtinCommands 개명 + availableCommands + SelfTest → 2. 호출부 교체 →
3. 편집기 분할 → build/selftest/all-build → 수동(업데이트 흐름 확인:
기본 최신·사용자 명령 유지·충돌 시 기본 우선)
