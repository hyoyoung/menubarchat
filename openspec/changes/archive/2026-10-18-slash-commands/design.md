# Design

## Context

프롬프트 템플릿은 사용자가 직접 관리(뉴스 다이제스트 등 루틴). 전개는
순수 텍스트 치환이라 기존 파이프라인(URL fetch·이미지·K 윈도우)이 그대로
재사용된다. 다중 URL fetch는 별도 변경(2단계)으로 분리했다.

## Goals / Non-Goals

**Goals:**

- `/명령` 입력 → 자동완성 → 프롬프트 전개 → (수정 가능) 전송

**Non-Goals:**

- 인자 치환 문법(`$1` 등), 명령의 조건부 동작, 빌트인 명령, 다중 URL

## Decisions

### D1: 저장 — SettingsStore에 `commands: [SlashCommand]`

`SlashCommand: Codable { name, prompt }`, UserDefaults에 배열로
영속화(기존 필드와 같은 패턴). 이름은 슬래시 없이 저장, 표기 시 `/` 접두.

### D2: 전개 — 순수 함수 `SlashCommands.expand(_ draft: String, commands:) -> String?`

초안의 첫 토큰(공백 전까지)이 `/이름`과 정확히 일치하면 그 토큰을
프롬프트로 치환하고 나머지 초안은 개행으로 이어 붙인다. 일치 없으면 nil
(전송은 원문 그대로). 접두 일치(`/ne`→news)는 자동완성 필터에만 쓰고
전개는 정확 일치만 — 전송 시점의 예측 전개는 하지 않는다.

### D3: UI — 입력창 위 오버레이 드롭다운

초안이 `/`로 시작하고 접두 일치 명령이 있을 때 입력 행 위에 오버레이
(세로 목록). 선택은 클릭 또는 Tab(첫 번째 일치 적용, `onKeyPress(.tab)`
가로채기 — 일치 없으면 기본 동작 유지).

### D4: 설정 편집기 — 이름 한 줄 + 프롬프트 여러 줄 행의 반복

기존 설정 섹션 스크롤 안에 행 단위 편집기(추가 버튼, 행별 삭제).
즉시 저장(기존 설정 필드와 동일한 편집-즉시-영속 패턴).

## Risks / Trade-offs

- [프롬프트에 URL 포함 시 fetch는 첫 URL만] — 알려진 제약(2단계
  변경으로 해결), 전개 자체에는 영향 없음.

## Migration Plan

1. SlashCommand 저장소 + expand() + SelfTest → 2. 설정 편집기 →
3. 드롭다운 → build/selftest/all-build → 수동 확인
