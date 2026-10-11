## MODIFIED Requirements

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
