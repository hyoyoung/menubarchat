# Design

## Context

PageFetcher는 현재 모든 http(s) URL을 동일하게 처리한다(HTML → 텍스트,
최대 2만 자, og:image). YouTube watch 페이지는 JS 중심이라 이 경로가
실패하거나 쓰레기 텍스트를 낸다. 제약: 서드파티 의존성 없음,
URLSession·파싱만으로 구현. SelfTest 하네스가 이미 존재한다.

## Goals / Non-Goals

**Goals:**

- YouTube URL에서 자막 텍스트를 확보해 기존 첨부 파이프라인에 공급
- 실패는 기존 오류 문자열로 격리 (새 오류 유형·새 UI 없음)

**Non-Goals:**

- 음성 인식(자막 없는 영상의 STT), 재생목록/Shorts 특수 처리,
- YouTube 외 동영상 사이트(Vimeo 등) 지원

## Decisions

### D1: 자막 경로 — watch 페이지의 captionTracks → timedtext

watch HTML에서 `"captionTracks":[...]` JSON을 추출해 각 트랙의
`baseUrl`·`languageCode`·`kind`(auto)를 얻고, 선택한 트랙을
`fmt=json3`로 내려받아 이벤트를 줄바꿈으로 조립한다. 외부 의존성 0.
대안(oEmbed 메타데이터)은 '요약' 수준이 못 되고, STT는 범위 밖.

### D2: 트랙 선택 규칙 — 수동 우선, 언어 선호순

1. 수동 자막(kind 없음)을 auto(kind="asr")보다 우선
2. 같은 그룹 안에서 시스템 언어 → 영어 → 첫 번째
규칙이 순수 함수로 떼어낼 수 있게 트랙 선택·ID 추출·json3 조립을
static helper로 구현해 SelfTest로 검증한다.

### D3: 실패 매핑 — 메타데이터 폴백 후 기존 오류

자막 확보 실패(트랙 없음, 빈 자막)면 이미 내려받은 watch HTML의
og:title·og:description으로 본문을 만들고 첫 줄 마커
"Video metadata (no captions): <제목>"로 메타데이터 기반임을 표시한다
(추가 네트워크 호출 없음). 메타데이터도 없으면 기존 오류 문자열로
표시한다. 새 오류 유형을 만들지 않는다.

### D4: 배치 — PageFetcher 내 특수 경로

`fetchPage` 시작부에서 YouTube URL을 감지(정규식으로 watch?v=,
youtu.be/<id>에서 동영상 ID 추출)해 자막 경로로 분기하고, 아니면 기존
일반 경로를 그대로 지난다. ChatModel·LLMClient·지시문 로직은 무변경.

## Risks / Trade-offs

- [비공식 엔드포인트 변경으로 장기 파손] → D3 폴백이 일반 오류로
  격리하고, 자막 경로 전체가 PageFetcher 안에 국한된다. 파손 시
  일반 HTML 경로로 되돌리는 것도 한 묶음 수정으로 충분하다.
- [연령제한·지역 동의 페이지에서 captionTracks 부재] → "no content"로
  사용자에게 즉시 보고, 대화는 유지.
- [json3 형식의 이벤트 중첩/개행] → 조립 시 이벤트별 줄바꿈으로 단순
  처리하고 2만 자 절단. 화면 자막 정렬 수준의 충실도는 요구하지 않는다.

## Migration Plan

1. 순수 helper(ID 추출, captionTracks 파싱, 트랙 선택, json3 조립) 구현
   + SelfTest
2. fetchPage에 YouTube 분기 연결
3. `swift build` → SelfTest → `./openspec-all-build.sh` → 수동 확인
