## 💰 Pennyway
> 지출 관리 SNS 플랫폼

| Version # | Revision Date | Description   | Author |
|:---------:|:-------------:|:--------------|:------:|
|  v0.0.1   |  2024.03.09   | 프로젝트 기본 설명 작성 | 최희진 |

<br/>

## 👪 iOS Team

<table>
    <tr>
        <td align="center">
            <a href="https://github.com/heejinnn">최희진</a>
        </td>
        <td align="center">
            <a href="https://github.com/yanni13">아우신얀</a>
        </td>
    </tr>
    <tr>
        <td align="center">
            <a href="https://github.com/heejinnn"><img height="200px" width="200px" src="https://avatars.githubusercontent.com/u/103185302?v=4"/></a>
        </td>
        <td align="center">
            <a href="https://github.com/yanni13"><img height="200px" width="200px" src="https://avatars.githubusercontent.com/u/122153297?v=4"/></a>
        </td>
    </tr>
</table>


<br/>

## 🌳 Branch Convention
> 💡 Git-Flow 전략을 사용합니다.
- main
    - 배포 가능한 상태의 코드만을 관리하는 프로덕션용 브랜치
    - PM(양재서)의 승인 후 병합 가능
- dev
    - 개발 전용 브랜치
    - 한 명 이상의 팀원의 승인 후 병합 가능
    - 기능 개발이 완료된 브랜치를 병합하여 테스트를 진행
- 이슈 기반 브랜치
    - 이슈는 `{티켓번호}-{브랜치명}`을 포함한다.
    - `feat/{티켓번호}-{브랜치명}`: 신규 기능 개발 시 브랜치명
    - `fix/{티켓번호}-{브랜치명}`: 리팩토링, 수정 작업 시 브랜치명
    - `hotfix/{티켓번호}-{브랜치명}`: 빠르게 수정해야 하는 버그 조치 시 브랜치명

<br/>

## 🤝 Commit Convention
> 💡 angular commit convention
- feat: 신규 기능 추가 
- fix: 버그 수정
- docs: 문서 수정
- rename: 주석, 로그, 변수명 등 수정
- style: 코드 포맷팅, 세미콜론 누락 (코드 변경 없는 경우)
- refactor: 코드 리팩토링
- test: 테스트 코드, 리펙토링 테스트 코드 추가
- chore: 빌드 업무 수정, 패키지 매니저 수정

<br/>

## 📌 Architecture
### MVVM

<div align="center">
  <img src="https://github.com/CollaBu/pennyway-client-ios/assets/103185302/08ca65ab-3938-4d7f-aed4-1116dedb241f" width="900" >
</div>

<br/>

## 📗 Tech Stack

### 1️⃣ Language 

- Swift 5

### 2️⃣ Framework
- SwiftUI
- Foundation

### 3️⃣ Library

- Alamofire 5.9.0
- CocoaPod 1.15.2


## 4️⃣ Dev Environment
- Xcode 15.3
- iOS 14 +
