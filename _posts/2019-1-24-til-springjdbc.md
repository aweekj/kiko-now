---
layout: post
title: TIL 2019-01-23
tags:
  - TIL
---

Today I Learned

TIL 2019-01-23

mysql driver 프로퍼티는 mysql 5.xx대와 8.xx대가 다르다.

ComponentScan : @component 애노테이션을 찾아서 전부 다 bean으로  
만들어버린다.

jdbcTemplate : Springjdbc에서 가장 핵심이 되는 객체.

기조ㅈ-> simple JDBC Import로 변환.

maven property pom.xml... 순서대로 쭉..
프로젝트 처음부터 만들어보기.
Spring을 공부했는데 스프링 프로젝트를 못만들면 안되니깐..

컨테이너 등장 배경  
리플렉션, 프록시, AOP..?

## 오늘 할 일

오늘은 Spring JDBC 코드를 봤음.  
Spring JDBC를 사용했을때의 장/단점을 말할 수 있어야 함. (발표)  
기존의 그냥 JDBC 프로그래밍과 비교해서 장단점을 직접 생각해보기  
Spring JDBC의 핵심 클래스. Simple JDBC insert 등의 핵심 객체에 대해 알기.  
BoardDaoImpl 완성해서 사용법을 공부하기.  
UserService 보여주셨으니, 내가 직접 BoardService도 완성하기.  

이제 서블릿부분만 고치면 게시판이 스프링으로 바뀌게 됨..

확실한 단점 한가지 : 프레임워크에 대해 공부해야 함.  