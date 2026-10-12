# AGENTS.md

OpenSpec 저장소. 작업 전 `openspec/project.md`과 관련
`openspec/specs/<capability>/spec.md`을 읽는다. 자잘한 수정 외 모든
작업은 변경 제안으로 시작한다(`openspec new change` 후 CLI 안내,
구현 전 승인), `swift build`로 검증하고 `openspec archive`로 마감한다.
`/opsx:*` 명령이 절차를 자동화한다.

1. 작업 전 `openspec/project.md`(규칙·플랫폼 함정)과 관련
   `openspec/specs/<capability>/spec.md`를 먼저 읽는다.
2. 자잘한 수정 외 모든 작업은 변경 제안으로 시작한다:
   `openspec new change <id>` 후 CLI 안내대로 아티팩트를 쓰고,
   구현 전 사용자 승인을 받는다.
3. 구현 후 `swift build`(통합은 `./openspec-all-build.sh`)으로 검증하고
   `openspec archive`로 마감한다.
4. `/opsx:*` 명령(explore/propose/apply/archive)이 있으면 위 절차를
   자동화한다.
원칙: YAGNI · SOLID · DRY · KISS · 간결한 변경.
