# Proposal

## Why

모델이 `$f(x) = \sum_i v_i (k_i^\top x)$` 같은 LaTeX 수식을 그대로
출력하면 원문 기호가 노출된다. 진짜 조판(웹뷰)은 메모리·스크롤 대가가
커서, 유니코드 근사 변환으로 빈출 부분집합을 읽을 수 있게 한다.

## What Changes

- 어시스턴트 메시지 렌더 전에 `$…$`/`$$…$$` 구간을 유니코드 수식으로
  변환한다(신규 순수 변환기): 그리스 문자, Σ·∫·√ 등 빈출 기호,
  하·첨자(유니코드에 있는 글자만), `^\top`→ᵀ, `\frac{a}{b}`→`(a)/(b)`,
  `\left`/`\right`·간격 명령 제거.
- 변환 불가 명령은 원문 유지(항상 원문 대비 같거나 나음). `\`·`^`·`_`
  없는 달러 구간(통화 등)은 수식이 아니라고 보아 변환하지 않는다.
- 변환은 markdown 파싱 전에 적용 — 수식 안 `_`가 이탤릭으로 오인되는
  부작용도 함께 제거된다. 렌더 캐시 경로에 흡수되어 비용 증가 없음.

## Capabilities

### New Capabilities

(없음)

### Modified Capabilities

- `chat-conversation`: 인라인 마크다운 표시 — 인라인 수식의 유니코드
  변환 명시

## Impact

- `Sources/MenuBarChat/MathFormatter.swift` 신규 (순수 함수 + 사전)
- `Sources/MenuBarChat/ContentView.swift` — markdown() 시작점에 변환
  삽입 (1줄)
- SelfTest — 변환 규칙 회귀 고정
- `openspec/specs/chat-conversation/spec.md` — 요구사항 1건 (아카이브 시
  반영)
