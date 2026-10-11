# AGENTS.md

이 프로젝트는 스펙 기반 개발을 위해 OpenSpec을 사용합니다.

코드를 변경하기 전에:

1. 규칙과 알려진 플랫폼 함정은 `openspec/project.md`를 먼저 읽는다.
2. 건드릴 코드와 관련된 `openspec/specs/<capability>/spec.md`를 읽는다.
3. 자잘한 수정을 제외한 모든 작업은 먼저 변경 제안을 만든다:
   `openspec/changes/<kebab-case-id>/`에 `proposal.md` (이유/내용),
   `specs/<capability>/spec.md` 델타 (ADDED / MODIFIED / REMOVED 요구사항과
   WHEN/THEN 시나리오), `tasks.md` (구현 체크리스트). 구현 전에 사용자
   승인을 받는다.
4. 구현 후 `swift build`로 검증하고, 스펙이 새로운 진실을 기술하도록
   갱신한 뒤 변경 폴더를 `openspec/changes/archive/<date>-<id>/`로 옮긴다.

시나리오 형식:

    #### Scenario: <이름>
    - **WHEN** <조건>
    - **THEN** <기대 결과>

## 코딩 원칙

- **YAGNI** — 지금 필요한 것만 만든다. "나중에 필요할 것 같은" 기능,
  설정, 추상화를 미리 추가하지 않는다.
- **SOLID** — 타입/모듈은 하나의 책임만 가지며, 구체 구현이 아닌
  추상에 의존하도록 설계한다.
- **DRY** — 같은 지식은 한 곳에만 둔다. 복붙 대신 기존 구현을
  재사용하거나 추출한다.
- **KISS** — 항상 가장 단순한 해결책을 택한다. 불필요한 간접층과
  일반화를 피한다.
