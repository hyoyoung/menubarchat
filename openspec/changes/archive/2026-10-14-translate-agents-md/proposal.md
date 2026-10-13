# Proposal

## Why

AGENTS.md가 한국어인데, 구조 키워드나 명령은 이미 영어라 혼합되어 있고
영어권 도구/에이전트가 읽기에도 영어가 무난하다.

## What Changes

AGENTS.md 전문을 영어로 번역한다. 내용·구조·링크는 그대로:

```markdown
# AGENTS.md

- Read `openspec/project.md` before working (rules, platform pitfalls,
  workflow).
- Principles
  - YAGNI
  - SOLID
  - DRY
  - KISS
  - Concise changes that never hurt readability or function
```

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

(없음 — 문서 전용 변경이라 `.openspec.yaml`에 `skip_specs: true` 설정)

## Impact

- `AGENTS.md`만 수정. 코드·스펙·project.md 무변경.
