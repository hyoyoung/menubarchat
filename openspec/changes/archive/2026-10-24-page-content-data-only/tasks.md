# Tasks

- [x] 1.1 PageFetcher: 정적 은닉 요소 제거 순수 함수(스타일·Tailwind
  `text-[0-8]px`·hidden/aria-hidden) + SelfTest — selftest 통과으로 확인
- [x] 1.2 렌더 추출: innerText 전 computedStyle 기반 font-size < 9px·
  visibility hidden·opacity 0 노드 제거 JS — `swift build` 통과으로 확인
- [x] 1.3 LLMClient system 파라미터 + PromptComposer: 지시문 적용
  요청에서 system(방어 서두 + 지시문) 구성, 페이지 본문·붙여넣기를
  `<untrusted_page_content>` 구획으로 래핑, user 끝 `[Instruction:]`
  suffix 제거 + SelfTest(구획·suffix 부재) — selftest 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: wuemeli.com 인젝션 페이지 URL 재전송 — 리듬 납치
  없이 정상 요약, 일반 URL·/news·붙여넣기 요약 회귀 없음

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-page-content-data-only/`로 이동
