---
layout: post 
title: querydsl 과 Repository

tags:
  - TIL/Java
---
Today I Learned

TIL 2019-02-14

## querydsl 과 Repository

post 목록 가져오는데 where절 조건이 경우에 따라서 막 바뀌는 Dynamic Query.  

## Spring Data JPA 에서 Dynamic Query를 처리하는 방법

1. JPA Criteria를 사용하는 방법
2. EntityManager를 직접 사용하는 방법
3. QueryDSL을 사용하는 방법

현업에서는 3번을 많이 사용한다.  

QueryDSL (http://www.querydsl.com/)
(http://www.mimul.com/pebble/default/2013/06/21/1371806174467.html)  
보통 DSL이라는 붙은 기술은 소스를 생성하는 기술이 사용된다.  
QueryDSL은 Domain(Entity)을 읽어들여 Q* 클래스 소스를 생성하여,  
다이나믹 SQL을 사용할 수 있도록 한다.  

보통 빌드도구(Maven, Gradle)에 플러그인을 설정하여  생성하도록 한다.  
의존성 추가.  

```
<dependency>
    <groupId>com.querydsl</groupId>
    <artifactId>querydsl-apt</artifactId>
    <version>4.1.4</version>
    <scope>provided</scope>
</dependency>

<dependency>
    <groupId>com.querydsl</groupId>
    <artifactId>querydsl-jpa</artifactId>
    <version>4.1.4</version>
</dependency>
```
플러그인도 추가해야한다.
```
<groupId>com.mysema.maven</groupId>
<artifactId>apt-maven-plugin</artifactId>
<version>1.1.3</version>
<executions>
    <execution>
        <goals>
            <goal>process</goal>
        </goals>
        <configuration>
            <outputDirectory>target/generated-sources/java/</outputDirectory>
            <processor>com.querydsl.apt.jpa.JPAAnnotationProcessor</processor>
        </configuration>
    </execution>
</executions>

```

maven에서 package를 실행  
mvn package  

target - generated sources - java 폴더 아래에 Q* 소스가 생성된다.  

---

***RepositoryCustom 에 다이나믹SQL이 필요한 메소드를 선언  
***RepositoryImpl을 구현  
1) ***RepositoryCustom을 구현  
2) ***QuerydslRepositorySupport클래스를 상속  
3) ***기본생성자에서 부모생성자를 호출. 이때 Entity클래스 정보를 전달.  
4) 메소드 구현시 QClass를 사용하여 구현한다.  
기존의 Repository인터페이스가 ***RepositoryCustom를 상속받도록 한다.

---
jquery, bootstrap

프론트 라이브러리도 maven, gradle을 추가할 수 있다.

    <!-- webjar -->
    <dependency>
        <groupId>org.webjars</groupId>
        <artifactId>jquery</artifactId>
        <version>3.3.1-2</version>
    </dependency>
    <dependency>
        <groupId>org.webjars</groupId>
        <artifactId>bootstrap</artifactId>
        <version>4.2.1</version>
    </dependency>
html문서 안에서 다음과 같이 사용

여러분들만의 정적파일 : css, image ....

ex> /resources/static/css/blog-home.css
아래와 같이 접근
