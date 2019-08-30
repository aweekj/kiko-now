---
layout: post
title: Spring MVC(2)
tags:
  - TIL
---

Today I Learned

TIL 2019-01-29

SpringMVC 이용, 기존 게시판 리팩토링작업중.

### Lombok

1. Lombok 플러그인을 설치, IntelliJ 재시작.
2. pom.xml 파일에 다음을 추가
```
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>1.18.4</version>
    <scope>provided</scope>
</dependency>

```
pom.xml 파일 선택하고 우측 버튼 클릭. maven 메뉴에서 reimport 선택.

3. lombok을 사용하는 프로젝트마다 한번씩은 설정해야 한다.  
    설정 - Build, Execution, Deployment  
          - 컴파일러
            - 어노테이션 프로세서
              - 설정.

4. lombok 이라는 도구는 컴파일전에 애노테이션을 읽어서 소스코드 수정.


5. lombok 애노테이션을 알아보자 (숙제.)  
    Data, Getter, Setter, Builder , ........

