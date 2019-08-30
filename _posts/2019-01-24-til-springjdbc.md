---
layout: post
title: Spring JDBC(1)
tags:
  - TIL/Java
---

Today I Learned

TIL 2019-01-24

>ComponentScan : @component 애노테이션을 찾아서  
  전부 다 spring bean(스프링이 관리하는 객체)으로 만들어버린다.  

>@ComponenetScan(basePackages = "examples.di") 와 같은 방법으로  
  특정 패키지 이하를 스캔한다.

## Spring JDBC

what is JDBC? -> Java DataBase Connectivity.

Spring JDBC : JDBC 프로그래밍에는 반복되는 개발 요소가 있다
* 커넥션의 연결/종료
* SQL문 실행
* SQL문 실행 결과 행에 대한 반복 처리
* 에외 처리 등  

저수준 세부사항을 스프링 프레임워크가 처리해준다.  
개발자는 필요한 부분만 개발하면 된다.  
* SQL문 정의
* 파라미터 설정
* ResultSet에서 결과를 가져온 후 레코드별로 필요한 처리

### JdbcTemplate : SpringJDBC에서 가장 핵심이 되는 객체.
* 리소스 생성, 해지를 처리해서 연결을 닫는 것을 잊어 발생하는 문제 등을  
피할 수 있도록 한다.
* Statement의 생성과 실행을 처리한다.
* SQL조회, 업데이트, 저장 프로시저 호출, ResultSet 반복호출 등을 실행한다.
* JDBC예외가 발생할 경우 org.springframework.dao 패키지에 정의되어 있는  
 일반적인 예외로 변환시킨다.

> JdbcTemplate 클래스가 제공하는 주요 메소드  
> * queryForObject :  
> 하나의 결과 레코드 중에서 하나의 칼럼 값을 가져올 때 사용함.  
> RowMapper와 함께 사용하면 하나의 레코드 정보를 객체에 매핑할 수 있음.
> * queryForMap  
> 하나의 결과 레코드 정보를 Map형태로 매핑할 수 있음  
> * queryForList  
> 여러 개의 결과 레코드를 다룰 수 있음  
> List의 한 요소가 한 레코드에 해당  
> 한 레코드의 정보는 qeuryForObject나 queryForMap을 사용할 때와 같음  
> * query  
> ResultSetExtractor, RowCallbackHandler와 함께 조회할 때 사용함  
> * update  
> 데이터를 변경하는 SQL(insert, update, delete)를 실행할 때 사용함


#### NamedParameterJdbcTemplate
* 데이터를 조작하는 처리를 JdbcTemplate 클래스에 위임하게 되는데,  
  JdbcTemplate클래스와의 차이점은 JdbcTemplate이 데이터 바인딩 시  
  '?'문자를 플레이스홀더로 사용하는 반면,  
  NamedParameterJdbcTemplate클래스는 데이터 바인딩 시  
  파라미터 이름을 사용할 수 있어서 '?'를 사용할 때보다 좀 더 직관적으로  
  데이터를 다룰 수 있게 해준다는 것이다.



#### 트랜잭션
> 스프링은 트랜잭션 관리를 위한 코드를 비지니스 로직에서 분리하기 위한  
> 구조나 다른 트랜잭션을 투명하게 처리할 수 있는 API를 제공한다.

> 스프링 트랜잭션 처리의 중심이 되는 인터페이스는   
> PlatformTransactionManager 이다.  
> 해당 인터페이스는 트랜잭션 처리에 필요한 API를 제공하며  
> 개발자가 API를 호출하는 것으로 트랜잭션 조작을 수행할 수 있다.

#### 리플렉션

#### 프록시

#### AOP


IoC 컨테이너 등장 배경에 대해 이해할 것.

~~mysql driver 프로퍼티는 mysql 5.xx대와 8.xx대가 다르다.  
(8.xx대에서 5.xx대로 바꿨다)~~

## Spring JDBC를 사용했을때의 장점
http://adnjavainterview.blogspot.com/2017/09/advantages-of-spring-jdbctemplate-over.html

Spring JDBC의 핵심 클래스. Simple JDBC insert 등의 핵심 객체에 대해 알기.  
BoardDaoImpl 완성해서 사용법을 공부하기.  
UserService 보여주셨으니, 내가 직접 BoardService도 완성하기.  

maven property pom.xml... 순서대로 쭉..
프로젝트 처음부터 만들어보기.
Spring을 공부했는데 스프링 프로젝트를 못만들면 안되니깐..

이제 서블릿부분만 고치면 게시판이 스프링으로 바뀌게 됨..

확실한 단점 한가지 : 프레임워크에 대해 공부해야 함.  
