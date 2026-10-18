# Design

## Context

언어가 systemLanguageName으로 파생·고정되어 있어 변경 불가. 치환 시점을
전송으로 옮기면 설정이 즉시 반영되고, 이미 저장된 사용자 텍스트는
건드리지 않는다("사용자 편집 우선" 원칙 유지).

## Goals / Non-Goals

**Goals:**

- Language 설정(시스템 언어 기본값) + `{language}` 전송 시점 치환

**Non-Goals:**

- UI 현지화(앱 자체 문구 번역), 언어별 프롬프트 분기, 자동 감지 재평가

## Decisions

### D1: appLanguage는 "언어명" 문자열

프롬프트에 바로 들어갈 영어 이름("Korean")을 저장. Picker 프리셋
[Korean, English, Japanese, Chinese, Spanish] + Custom(모델 선택과 같은
패턴). 기본값은 기존 `systemLanguageName` 계산을 init에서 1회 사용.

### D2: 치환은 한 곳에서 — `applyingLanguage(_ text:)`

`{language}` 치환을 SettingsStore가 아니라 소비 경계에서 수행:
`SlashCommands.expand` 호출 직후(ChatModel.send)와 PromptComposer의
지시문 부착 시. 치환 함수는 `String.replacingOccurrences` 한 준공으로
간단하지만 SelfTest로 고정(시드 프롬프트·지시문·커스텀 명령 3경로).

### D3: 시드·기본값은 플레이스홀더 리터럴

defaultCommands와 urlHandling 기본값이 `{language}` 리터럴을 담는다.
시드는 저장되지 않으므로(편집 시만) 매 실행 최신 상태. 사용자가 과거에
저장한 리터럴 언어("Korean") 텍스트는 그대로 — 치환 대상이 아니므로
동작 불변.

## Risks / Trade-offs

- [플레이스홀더 문법 노출] 커스텀 명령 작성자에게만 노출되는 옵션
  기능 — 문서 불필요(설정 라벨로 충분).
- [저장된 구형 기본값] 이미 저장된 urlHandling 리터럴은 언어 변경과
  무관 — 사용자가 수동으로 `{language}`로 고치면 따라옴.

## Migration Plan

1. appLanguage + 기본값·시드 교체 + SelfTest → 2. 치환 적용 +
SelfTest → 3. Picker → build/selftest/all-build → 수동(언어 전환
다이제스트 확인)
