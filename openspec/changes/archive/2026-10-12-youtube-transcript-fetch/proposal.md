# Proposal

## Why

YouTube URL을 붙여넣으면 PageFetcher가 일반 HTML처럼 다뤄서 본문 추출이
실패하거나("no content") 메뉴 잔해 같은 쓰레기 텍스트가 걸린다. 영상의
실제 내용(자막)을 확보하면 기존 파이프라인(미리보기, 마지막 요청 전문
첨부, URL 지시문 요약)이 나머지를 그대로 처리한다.

## What Changes

- PageFetcher가 YouTube 동영상 URL(watch, youtu.be)을 감지하면 일반
  HTML 경로 대신 자막을 가져온다: watch 페이지에서 `captionTracks`를
  추출 → 언어 선호순(수동 자막 우선, 시스템 언어, 영어, 첫 번째)으로
  트랙 선택 → timedtext를 내려받아 자막 텍스트 조립(최대 2만 자,
  기존 제한과 동일).
- 자막 확보에 실패하면(자막 없음, 연령제한, 엔드포인트 변경) 이미 받은
  watch 페이지의 메타데이터(og:title, og:description)를 본문으로 폴백하고
  첫 줄 마커로 메타데이터 기반 요약임을 표시한다. 메타데이터도 없으면
  기존 오류 미리보기 문자열("no content" 등)로 표시한다. 새 오류 유형을
  만들지 않는다.
- 썸네일·ID·도메인 미리보기, 첨부 ID 부여, 지시문 요약은 기존 웹 페이지
  읽기 요구사항을 그대로 따른다.
- 자막 추출 파서(동영상 ID, 트랙 선택, 텍스트 조립)는 SelfTest로 검증한다.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: YouTube 동영상 URL의 본문을 자막으로 읽는 요구사항
  추가 (기존 웹 페이지 읽기 흐름 안의 특수 경로)

## Impact

- `Sources/MenuBarChat/PageFetcher.swift` — YouTube 감지 + 자막 fetch
  경로 추가
- `Sources/MenuBarChat/SelfTest.swift` — 파서 유닛테스트 추가
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
