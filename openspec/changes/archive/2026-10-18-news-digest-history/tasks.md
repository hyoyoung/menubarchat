# Tasks

- [x] 1.1 `NewsHistory.swift`: 항목 Codable, `trimmed(entries:now:)`
  순수 함수(24h 만료 제거·최근 5개 캡·최신순) + 파일 로드/append(만료
  재작성 포함) + SelfTest 3건(만료 제거·캡·순서) — selftest 통과으로 확인
- [x] 1.2 내장 news 프롬프트에 이전 다이제스트 지시문 + `{previous}`
  추가, 전개 시 치환(24h 내 직전 2개, 없으면 "none") — `swift build`
  통과로 확인
- [x] 1.3 stream() 정상 종료 시 뉴스 명령 응답을 이력에 append(오류
  종료 제외) — `swift build` 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: `/news` 두 번 연속 실행 — 두 번째 다이제스트가
  첫 번째 기사를 반복하지 않는지, 24시간 경과 항목 제거·첫 실행
  "none" 동작(파일 확인), 표시 무변경

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-news-digest-history/`로 이동
