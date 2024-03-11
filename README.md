## Commit title convention
- `[part/type] Feature description`
  - e.g. `[frontend/feature] Login 화면 구현`

### 1. Commit 메시지 구조
~~~
type : subject

body 

footer
~~~

### 2. Commit Type
- feat : 새로운 기능 추가  
- fix : 버그 수정  
- docs : 문서 수정  
- style : 코드 포맷팅, 세미콜론 누락, 코드 변경이 없는 경우  
- refactor : 코드 리펙토링  
- test : 테스트 코드, 리펙토링 테스트 코드 추가  
- chore : 빌드 업무 수정, 패키지 매니저 수정  

---

## Branch naming convention
- `{feature,fix}/{name}/{part}/{feature-description}` (브랜치명에는 영문과 `/` 만 포함 되도록)

1. master: 라이브 서버에 제품으로 출시되는 브랜치.  
2. develop: 다음 출시 버전을 대비하여 개발하는 브랜치.  
3. feature: 추가 기능 개발 브랜치. develop 브랜치에 들어간다.  


---

## PR title convention
- `[part/type] Feature description`
  - e.g. `[frontend/feature] Login 화면 구현`

## 반영 브랜치
### feature (기능 개발) -> develop -> master

## 작성 내용
~~~
## 개요 :mag:

`어떤 이유에서 이 PR을 시작하게 됐는지에 대한 히스토리를 남겨주세요.`

## 작업사항 :memo:

`해당 이슈사항을 해결하기 위해 어떤 작업을 했는지 남겨주세요.`

## 테스트 방법

`리뷰하는 사람이 어떻게 테스트할 수 있을지 간략히 써주세요.`
~~~