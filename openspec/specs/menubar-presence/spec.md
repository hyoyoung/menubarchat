# 메뉴 막대 상주 기능 스펙

## 목적

앱은 macOS 메뉴 막대에만 존재한다: 아이콘 하나, 채팅 패널, 우클릭 메뉴.
그 밖의 것은 화면에 절대 나타나지 않는다.

## Requirements

### Requirement: 메뉴 막대 아이콘
앱은 `ellipsis.bubble` 심볼을 가진 시스템 상태 항목 하나만 표시해야 하며,
실행 시 Dock 아이콘, 메뉴 막대 창, 그 외 어떤 창도 나타나서는 안 된다.

#### Scenario: 앱이 실행될 때
- **WHEN** 앱이 시작되면
- **THEN** 메뉴 막대 아이콘만 보이고 창은 없다

### Requirement: 채팅 패널 토글
좌클릭하면 아이콘 아래에 채팅 패널을 표시하고, 다시 좌클릭하면 숨긴다.
패널은 모든 Space에 참여하는 크기 조절 가능한 floating `NSPanel`이며,
아이콘 아래 중앙(화면 경계로 클램프)에 위치하고 표시될 때 키보드
포커스를 가진다.

#### Scenario: 사용자가 아이콘을 좌클릭
- **WHEN** 패널이 숨겨진 상태에서 아이콘을 클릭하면
- **THEN** 아이콘 아래에 패널이 나타나고 메시지 입력란에 포커스가 간다

#### Scenario: 다시 좌클릭
- **WHEN** 패널이 보이는 상태에서 아이콘을 클릭하면
- **THEN** 패널이 숨겨지고 설정 섹션 상태가 초기화된다

### Requirement: 우클릭 메뉴
우클릭하면 "About MenuBarChat"과 "Quit MenuBarChat"(단축키 Cmd+Q)가 있는
컨텍스트 메뉴를 표시한다. About은 표준 정보 패널 대신, 앱 이름의 구성
(Menu Bar + Chat)과 설명, 버전을 담은 미니 팝업을 아이콘 아래에 띄운다.
팝업은 Close 버튼으로 닫는다. Quit은 앱을 종료한다.

#### Scenario: 사용자가 아이콘을 우클릭
- **WHEN** 아이콘을 우클릭하면
- **THEN** 정보와 종료가 있는 메뉴가 나타난다

#### Scenario: About 선택
- **WHEN** "About MenuBarChat"을 선택하면
- **THEN** 아이콘 아래에 이름 정보 미니 팝업이 나타난다

#### Scenario: 팝업 닫기
- **WHEN** 팝업의 Close를 누르면
- **THEN** 팝업이 사라진다

#### Scenario: 종료 선택
- **WHEN** "Quit MenuBarChat"을 선택하면
- **THEN** 프로세스가 종료된다
