# Proposal

## Why

API 키가 비어 있어도(저장값·환경변수 모두 없음) 요청이 `Bearer `로
그대로 나가 401 응답이 돌아온 뒤에야 사용자가 원인을 알게 된다. API
호출이 낭비되고 피드백도 늦다.

## What Changes

- `send()`가 잘라낸 API 키가 비면 요청을 보내지 않고, 기존 오류 채널인
  어시스턴트 오류 말풍선으로 안내를 표시한다. 사용자 초안은 유지한다.
- settings 스펙에 해당 요구사항을 추가한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `settings`: API 키 부재 시 전송 차단 및 안내 요구사항 추가

## Impact

- `Sources/MenuBarChat/ChatModel.swift` — `send()` 가드 추가 (수 줄)
- `openspec/specs/settings/spec.md` — 요구사항 1건 (아카이브 시 반영)
