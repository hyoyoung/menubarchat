# Proposal

## Why

README.md가 모듈 분리 전 상태(Layout 3파일, ChatModel이 SSE 담당)에
머물러 있고 이번 세션의 기능·명령이 전부 빠져 있다. openspec/README.md의
"구조 키워드는 영어 유지" 목록에 `## Purpose`가 없어, 한국어 헤더로
스펙이 깨지는 사고(이번 세션에 실제 발생)의 재발을 문서가 막지 못한다.

## What Changes

- README.md:
  - Layout을 현재 9파일 구조로 갱신 (LLMClient, SettingsStore,
    PageFetcher, PromptComposer, SelfTest 포함)
  - 이번 세션 기능 반영 — 빈 API 키 전송 차단, 어시스턴트 인라인
    마크다운, YouTube 자막(메타데이터 폴백) 요약
  - 명령 안내 추가 — `swift run MenuBarChat --selftest`,
    `./openspec-all-build.sh`
- openspec/README.md: 키워드 목록에 `## Purpose` 추가
- AGENTS.md, `openspec/project.md`, 스펙 4종은 이미 현행이라 변경 없음

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

(없음 — 문서 전용 변경이라 `.openspec.yaml`에 `skip_specs: true` 설정)

## Impact

- `README.md`, `openspec/README.md`만 수정. 코드·스펙 무변경.
- 검증: 문서에 적힌 명령을 그대로 실행해 통과 확인(selftest,
  통합 빌드).
