---
layout: post
title: TIL 2019-01-08
tags:
  - Java
  - post
  - Servlet
  - JSP
  - BootStrap
---

Today I Learned

TIL 2019-01-08

## HttpServlet API 와 WAS

브라우저에서 연결요청을 보내면 WAS에서는  
HttpServletRequest 와 HttpServletResponse 객체를  
만들어 요청과 응답 정보를 받는다.  
이는 요청은 요청끼리, 응답은 응답끼리 모아서 '응집도'를  
높이기 위함이다.

이렇게 받은 요청에 담긴 Context Path에 해당하는  
Web Application을 WAS가 찾아낸다.  
찾는 Context Path가 없으면 404에러로 응답하고,  
Path가 없어도 404에러를 응답한다..  
(path에서 해당 파일을 찾을 수 없다는 뜻)  

찾아낸 Web Application이 정적 리소스이면  
Default Servlet에서 처리해서 응답하고,  
동적 리소스이면 Servlet, JSP 가 처리해서 응답한다.

HttpServlet 클래스는  
init(), destroy(), doGet(), doPost() 등의 메소드를  가지고 있다.  
HttpServlet클래스를 상속받아서 원하는 Servlet 클래스를 만들 수 있다.
Servlet은 Path를 가지고 있어야 한다.  
'어떤 Path로 요청이 왔을 때 이 Servlet이 실행된다'  
라는 게 정해져있어야 한다.  
(Servlet 스펙 3.0 미만인 경우 Web.xml에서,  
3.0 이상에서는 Annotation '@'을 이용해서 설정한다.)

우리가 만들어 볼 실습 예제에서  
/myweb/hello 는 myweb이라는 Context Path에 있는  
hello라는 Path를 가정한다.  

웹브라우저로부터 요청이 들어오면(HttpServletRequest),  
WAS는 해당 요청에 들어있는 Context Path와 Path 경로를 확인하고  
해당 경로의 파일이 메모리에 올라와있는지 확인한 뒤  

1 : 메모리에 없으면  
 인스턴스를 생성하고 init()메소드를 호출하고 Service()메소드를 실행한다.  
-> 실행된 결과를 HttpServletResponse로 웹브라우저에 응답한다.  

2 : 메모리에 있으면  
 Service()메소드를 실행한다.  
 -> 실행된 결과를 HttpServletResponse로 웹브라우저로에 응답한다.

이전에 쓰레드와 소켓 공부를 위해 채팅프로그램을 만들었을 때  
여러 쓰레드에서 동시에 하나의 객체를 공유하는 경우를 공유객체  
라고 배웠는데, 공유객체에 필드가 있으면 문제가 생길 가능성이 커진다.  
따라서 Servlet을 만들 때에는 필드 선언을 되도록 하지 않고,  
만약에 필드 선언을 해야 한다면 Service()메소드에서 필드를 사용해도  
문제가 없을 경우에만 선언하도록 한다.

init()메소드에는 초기화하도록 구현한다.  

service()메소드는 사용자가 요청할 때 호출하는 메소드.  

---

### service() 메소드 오버라이딩
  
  요청에 따라 http 메소드(POST,GET,DELETE 등등)를  
  요청대로 처리하기 위해서는 service()메소드 전체를 오버라이딩하지 않고  
  doGet() 메소드나 doPOST() 메소드만 오버라이딩 할 필요가 있다.  ([참고](http://jkkang.net/java/servlet/servlet-3.html))  

---

### Servlet 작성 연습 스펙

1. Servlet 3.0 기준  
  Hello를 찍는 Servlet을 만들기.

2. Maven 프로젝트로 만들기  
  Maven 프로젝트를 만들어서 hello Servlet을 하나 추가  
  *IntelliJ IDEA 사용*

3. 완성되면 웹브라우저에서 출력

---

### 숙제
* Servlet 동작과정, 라이프사이클 더 공부하기
* Tomcat 프로세스 우아하게 종료시키는 방법 알아보기
* Html 폼 태그 작성하는 방법 공부해서   
   webapp 폴더에 form1.html을 만들어 제출한 폼을  
   Servlet과 연동시켜보기 (*BootStrap 활용*)
* Cookie, Session, forward, redirect 네 가지 용어의 의미 파악하기.
* 내일 MVC Model 1 , 2 수업을 위한 예습.