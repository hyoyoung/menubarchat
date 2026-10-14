# Design

## Context

glm-5.3-flash는 네이티브 멀티모달(공식 문서 확인): content 파트 배열에
`{type:"image_url", image_url:{url}}`을 추가하며 Base64 Data URL을
지원한다. 앱에는 이미 ⌘V 가로채기(limit-paste-formats), 단일 슬롯
스테이징(stagedPaste), 첨부 ID 시스템(ID<n>/ID<n>p + 언급 재포함),
응답 대기 말풍선이 갖춰져 있다. 미검증 사항: flash 외 모델의 이미지
지원 — 문서로 확인된 것은 flash 계열뿐이다.

## Goals / Non-Goals

**Goals:**

- flash 계열 모델에서 이미지 붙여넣기→질의→답변의 최소 완결 경로
- 기존 첨부 패턴(ID·스텁·재포함)과의 일관성

**Non-Goals:**

- 여러 이미지 동시 첨부, 드래그앤드롭, 파일(PDF 등) 입력, 비디오,
  이미지 편집, flash 외 모델 지원

## Decisions

### D1: 모델 게이트 — `model.lowercased().contains("flash")`

사용자 제약("glm*-flash만 수용"). flash가 아니면 기존 거부 안내 유지.
문서로 검증된 계열만 수용하는 보수적 화이트리스트이며, 커스텀 모델명은
기본 거부다. 게이트는 ChatModel의 계산 프로퍼티로 두고 가로채기와
전송 양쪽이 같은 판정을 쓴다.

### D2: 단일 이미지 슬롯 — `@Published var stagedImage: Data?`

stagedPaste와 동일한 단일 슬롯. 칩은 썸네일(NSImage 미리보기) + 삭제
버튼(초안 되돌리기 없음 — 이미지는 편집 대상이 아님). 스테이징 시점에
리사이즈까지 끝낸 JPEG Data를 저장해 전송 경로를 가볍게 둔다.

### D3: ImageEncoder — 순수 헬퍼 + SelfTest

`ImageEncoder.jpegDataURL(from: NSImage, maxDimension: 1568) -> String?`
(리사이즈 → JPEG 0.7 → `data:image/jpeg;base64,…`). SelfTest는 생성한
큰 이미지(2000px)로 1568 캡과 Data URL 접두를 검증한다. 문서 권장은
이미지 URL이지만 로컬·무서버 제약상 Base64 Data URL(공식 지원)이
유일한 경로다.

### D4: content 파트 — PromptComposer에 파트 변형 추가

`apiContentParts(...)`는 마지막 사용자 메시지에 이미지가 있으면
`[[String: Any]]` 파트 배열(텍스트 파트 + image_url 파트, 기존 스텁·
재포함 로직 재사용)을, 아니면 nil을 반환한다. LLMClient는 이 값이 있을
때만 해당 메시지 content를 배열로 교체한다 — 기존 문자열 경로는 무변경.

### D5: ID<n>i — 기존 패턴의 세 번째 접미

Message에 `var imageData: Data?` 추가. 통합 카운터로 `ID<n>i` 부여,
마지막 요청에만 실리고 이후 `[Image ID<n>i]` 스텁, 언급 정규식에 `i`
접미 추가(기존 `ID(\d+)p?` → `ID(\d+)([pi]?)`)하여 재포함 시 Data URL을
다시 부착한다. 접힘 라벨 표기도 기존 형식을 따른다.

### D6: 표시 — 칩 썸네일 + 말풍선 썸네일

스테이징 칩과 전송된 사용자 말풍선 모두 `NSImage(data:)` →
`Image(nsImage:)` 썸네일(높이 ~120pt, 모서리 둥글게).

## Risks / Trade-offs

- [Base64 페이로드 크기] — 1568px/JPEG 0.7이면 통상 200~500KB. 토큰
  비용은 비전 토큰으로 과금되며 리사이즈가 상한을 만든다.
- [비전 토큰 응답 지연] — 응답 대기 말풍선이 이미 존재해 UX 공백 없음.
- [flash 외 모델 오남용] — 게이트가 문서 검증 계열로 한정. 새 모델
  추가 시 게이트 상수만 갱신하면 된다.

## Migration Plan

1. ImageEncoder + SelfTest → 2. ChatModel(게이트·슬롯·전송) →
3. 가로채기 분기 → 4. 칩·썸네일 UI → 5. PromptComposer 파트·ID<n>i +
SelfTest → 6. LLMClient 혼합 content → `swift build` → selftest →
`./openspec-all-build.sh` → 수동 확인(스크린샷 질의)
