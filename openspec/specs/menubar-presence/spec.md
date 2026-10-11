# 메뉴 막대 상주 기능 스펙

## 목적

앱은 macOS 메뉴 막대에만 존재한다: 아이콘 하나, 채팅 패널, 우클릭 메뉴.
그 밖의 것은 화면에 절대 나타나지 않는다.

## Requirements

### Requirement: 메뉴 막대 아이콘
앱은 `ellipsis.bubble` 심볼의 시스템 상태 항목 하나만 표시하며, 실행 시
Dock 아이콘이나 그 외 어떤 창도 나타나지 않는다.

### Requirement: 채팅 패널 토글
좌클릭하면 아이콘 아래에 채팅 패널을 표시하고, 다시 좌클릭하면 숨기며
설정 섹션 상태를 초기화한다. 패널은 모든 Space에 참여하는 크기 조절
가능한 floating `NSPanel`로, 아이콘 아래 중앙(화면 경계로 클램프)에
위치하고 표시될 때 입력란에 키보드 포커스를 가진다.

### Requirement: 우클릭 메뉴
우클릭하면 "About MenuBarChat"과 "Quit MenuBarChat"(Cmd+Q) 컨텍스트
메뉴를 표시한다. About은 표준 정보 패널 대신 앱 이름 구성(Menu Bar +
Chat)과 설명, 버전을 담은 미니 팝업을 아이콘 아래에 띄우며 Close 버튼으로
닫는다. Quit은 앱을 종료한다.
