# Proposal

## Why

시드된 `news` 명령 프롬프트가 한국어 하드코딩이다. 프롬프트 자체는
영어로 통일하고(모델 지시의 일관성), **출력 언어는 URL 지시문 기본값과
같은 방식** — 시스템 기본 언어(`summarize it in <language>` 패턴)로
요청한다. 시드는 저장된 목록이 없을 때만 적용되고 현재 이 머신에 저장된
명령 목록이 없어(초기화 시 didSet 저장을 트리거하지 않음) 업데이트 후
다음 실행에서 새 프롬프트가 바로 시드된다.

## What Changes

- `defaultCommands`의 news 프롬프트를 영어 템플릿으로 교체하고 출력
  언어를 `systemLanguageName` 보간으로 지시한다.
- `systemLanguageName`을 `nonisolated`로 공개(비격리 정적 상수에서
  참조).

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `settings`: 영속화 — 시드 프롬프트 설명(영어 템플릿 + 시스템 언어
  출력 지시)

## Impact

- `Sources/MenuBarChat/SettingsStore.swift` — 프롬프트·언어 헬퍼 접근자
- SelfTest — 시드 프롬프트 회귀 갱신
