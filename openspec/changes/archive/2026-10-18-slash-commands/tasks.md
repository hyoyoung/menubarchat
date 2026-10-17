# Tasks

## 1. 모델

- [x] 1.1 SettingsStore에 `commands` 영속화(Codable 배열, 기본 비어
  있음) + `SlashCommands.expand()` 순수 함수(첫 토큰 정확 일치 치환,
  나머지 개행 연결) + SelfTest(전개·미일치·잔여 텍스트) — selftest
  통과로 확인

## 2. UI

- [x] 2.1 설정 섹션에 명령 편집기 추가(이름 + 프롬프트 + 추가/삭제,
  즉시 저장) — `swift build` 통과로 확인
- [x] 2.2 입력창 위 자동완성 드롭다운(접두 필터, 클릭 선택 → 전개) —
  `swift build` 통과로 확인
- [x] 2.3 `ChatModel.send()` 시작점에 전개 적용 — `swift build` 통과로
  확인
- [x] 2.4 입력창 Tab 완성: 드롭다운 표시 중 Tab이면 첫 일치 명령 적용
  (`onKeyPress(.tab)` 가로채기, 일치 없으면 기본 동작) — `swift build`
  통과로 확인
- [x] 2.5 `news` 기본 명령 시딩: 저장된 목록이 없을 때만 4개 뉴스 사이트
  종합 요약 프롬프트 명령 1개를 기본값으로 + SelfTest(기본 명령
  내용) — selftest 통과로 확인

## 3. 검증

- [x] 3.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 3.2 수동 확인: 설정에서 `/news` 명령 등록 → 입력창 `/ne` 입력 시
  드롭다운 → 선택 시 전개 → 수정 후 전송, `/news` 직접 Enter 전개,
  미등록 `/foo` 원문 전송, 재시작 후 명령 유지

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-slash-commands/`로 이동
