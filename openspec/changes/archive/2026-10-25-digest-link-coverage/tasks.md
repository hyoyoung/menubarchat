# Tasks

- [x] 1.1 PageFetcher 앵커 상한 40 → 80 + SelfTest 기대치 갱신 — selftest
  통과으로 확인
- [x] 1.2 내장 news 프롬프트에 매치 완화 문장("Attach the most plausible
  anchor URL even when the title is paraphrased; omit the link only when
  no plausible candidate exists.") 추가 + SelfTest — selftest 통과으로 확인

## 2. 검증

- [x] 2.1 `swift run MenuBarChat --selftest` 회귀 없음 +
  `./openspec-all-build.sh` 통과
- [x] 2.2 수동 확인: /news — 링크 커버리지가 눈에 띄게 상승(무링크 항목
  감소), 클릭 정상, 오탐(다른 기사로 연결) 눈으로 확인

## Workflow follow-up

- 검증 완료 후 변경 폴더를
  `openspec/changes/archive/<date>-digest-link-coverage/`로 이동
