# Design

## Context

비트맵 페인팅 도구는 없지만 SVG는 코드로 직접 그릴 수 있고 GitHub
markdown에서 바로 렌더된다. 벡터라 어느 해상도에서도 깨끗하고, 텍스트
형태라 git diff·수정에도 강하다.

## Goals / Non-Goals

**Goals:**

- "무엇인지"를 친근하게 보여주는 일러스트 2장 (기능 변화에 둔감)

**Non-Goals:**

- 실제 스크린샷, 애니메이션, 다크 모드 대응, 정확한 UI 재현

## Decisions

### D1: 손작성 SVG — 플랫 + 손그림 톤

- 캔버스 약 800x520, 흰 배경(README 라이트 테이트와 자연 병합)
- 팔레트: 파스텔 (배경 #FFF8F0 계열, 보조 #A8C7E8 파랑, #F4C2C2 핑크,
  #B5D9B5 그린, 포인트 #F0A860 주황), 스트로크는 짙은 회청색(#3D4852)
  3~4px 라운드 캡
- 손그림감: 완전한 직사각형 대신 살짝 기운/굽은 path, 스파클·점
  데코, 텍스트는 손글씨 계열 대신 일반 서체를 캐주얼하게 배치
- 실제 UI 요소(추론 말풍선·ID 라벨)는 "연상" 수준으로만 — 디테일 재현
  금지(기능 변화에 낡지 않게)

### D2: 두 장의 구도

1. chat.svg — 좌상단 메뉴 막대 조각(말풍선 아이콘 + 패널 드롭다운 암시),
   패널 안: 인사 사용자 말풍선(오른쪽), 반짝임 답변 말풍선(왼쪽),
   하단 입력창과 전송 화살표
2. url-summary.svg — URL 텍스트 + 지구본 → 물결/스파클 화살표 → 문서
   카드(제목 줄·본문 줄) → 요약 말풍선(한국어 짧은 문장), 좌에서 우로
   흐르는 구도

### D3: 파일·삽입

- `docs/illustrations/chat.svg`, `docs/illustrations/url-summary.svg`
- README Features 해당 불릿 아래 `![설명](docs/illustrations/...)`
- 검증: 로컬에서 크기 확인 + GitHub 렌더 확인(SVG는 원격에서 표시됨)

## Risks / Trade-offs

- [손작성 SVG 퀄리티 편차] — 구도를 도형 15개 내외로 제한해 단순하게.
  마음에 들지 않으면 path 좌표만 조정하면 된다(텍스트 자산이라 수월).

## Migration Plan

1. chat.svg 작성 → 2. url-summary.svg 작성 → 3. README 삽입 →
4. 로컬 확인 → 푸시 후 GitHub 렌더 확인
