# MenuBarChat — OpenSpec

Z.AI GLM 모델용 macOS 메뉴 막대 채팅 클라이언트, MenuBarChat의
스펙 기반 개발 프로젝트 맵입니다.

- `openspec/specs/` — 앱의 현재 검증된 동작 (단일 진실 공급원)
- `openspec/changes/` — 진행 중인 변경 제안 (변경마다 폴더 하나)
- `openspec/changes/archive/` — 완료되어 보관된 변경들
- `openspec/project.md` — 프로젝트 규칙, 빌드 명령, 레이아웃

## 스펙 형식

스펙은 순수 Markdown입니다. 기준 스펙은 `specs/<capability>/spec.md`에
위치하며 `## Requirements` 섹션 아래 `### Requirement:` 블록들, 각 블록마다
`- **WHEN**` / `- **THEN**` 불릿을 사용하는 `#### Scenario:` 블록들로
구성됩니다.

변경 제안은 `changes/<change-id>/specs/<capability>/spec.md` 안에 델타
헤더(`## ADDED Requirements`, `## MODIFIED Requirements`,
`## REMOVED Requirements`)를 사용합니다.

> 참고: `Requirement:`, `Scenario:`, `WHEN`, `THEN` 같은 구조 키워드는
> 공식 CLI 및 에이전트 파싱 호환성을 위해 영어를 유지하고, 그 외 내용은
> 한국어로 작성합니다.
