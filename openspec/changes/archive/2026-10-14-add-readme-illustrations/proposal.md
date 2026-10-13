# Proposal

## Why

README가 텍스트만 있어 프로그램의 모습을 한눈에 보여주지 못한다. 실제
스크린샷은 기능이 바뀔 때마다 낡아가므로, 친근한 손그림 느낌의
일러스트로 정체성만 표현해 오래 쓴다.

## What Changes

- 손그림 스타일 SVG 일러스트 2장을 직접 작성해 `docs/illustrations/`에
  추가하고 README Features 섹션에 삽입한다:
  1. **간단한 대화** — 메뉴 막대 아이콘 + 채팅 패널, 인사 말풍선과
     반짝이는 답변 말풍선
  2. **URL 요약 처리** — URL + 지구본이 문서 카드를 거쳐 요약 말풍선으로
     흘러가는 흐름
- 스타일: 부드러운 라운드, 파스텔 팔레트, 약간의 손그림 굴곡(불규칙한
  곡선). 실제 UI를 정확히 묘사하지 않는다(기능 변화에 둔감하게).

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

(없음 — 문서·에셋 전용이라 `.openspec.yaml`에 `skip_specs: true` 설정)

## Impact

- `docs/illustrations/chat.svg`, `docs/illustrations/url-summary.svg` 신규
- `README.md` — Features 두 불릿 아래 삽입
- 코드 무변경. SVG는 GitHub에서 바로 렌더된다.
