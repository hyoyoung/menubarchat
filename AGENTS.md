# AGENTS.md

OpenSpec 스펙 기반 개발 저장소.

1. 작업 전 `openspec/project.md`(규칙·플랫폼 함정)과 관련
   `openspec/specs/<capability>/spec.md`를 먼저 읽는다.
2. 자잘한 수정 외 모든 작업은 변경 제안으로 시작한다:
   `openspec new change <id>` 후 CLI 안내대로 아티팩트를 쓰고,
   구현 전 사용자 승인을 받는다.
3. 구현 후 `swift build`(통합은 `./openspec-all-build.sh`)으로 검증하고
   `openspec archive`로 마감한다.
4. `/opsx:*` 명령(explore/propose/apply/archive)이 있으면 위 절차를
   자동화한다.

## 코딩 원칙

- **YAGNI** — 지금 필요한 것만 만든다. "나중에 필요할 것 같은" 기능,
  설정, 추상화를 미리 추가하지 않는다.
- **SOLID** — 타입/모듈은 하나의 책임만 가지며, 구체 구현이 아닌
  추상에 의존하도록 설계한다.
- **DRY** — 같은 지식은 한 곳에만 둔다. 복붙 대신 기존 구현을
  재사용하거나 추출한다.
- **KISS** — 항상 가장 단순한 해결책을 택한다. 불필요한 간접층과
  일반화를 피한다.
- **간결한 변경** — 모든 변경(코드, 스펙, 문서 포함)은 간결하게 쓴다.
  가독성과 기능을 해치지 않는 한 최대한 최소화한다.
