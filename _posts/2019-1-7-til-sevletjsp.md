---
layout: post
title: TIL 2019-01-07
tags:
  - Java
  - post
  - Servlet
  - JSP
  - BootStrap
---

Today I Learned

TIL 2019-01-07

## Servlet 과 JSP.


앞으로 배울 내용에 대한 이해를 위해 이 두가지를 학습해야함.

JSP중에서는 JSTL과 EL을 살펴보고

Servlet에서는 더 중요한 라이프싸이클에 대해 공부할 예정.

Servlet이 어떻게 등장했는지에 대한 이해가 더 중요.

JSP는 Servlet과 기술적인 부분이 같다고 보면 되기 때문에 둘이 묶어서 공부하면 좋음.

---
## WAS(Web Application Server)

* 정적 Page -> html파일, css파일 : 프로그래밍적 요소가 없는 페이지.
* 동적 Page -> 프로그래밍적 요소가 들어가는 페이지.  
  Node.js , django, Servlet/JSP를 사용하는데 Servlet/JSP를 더 강화시킨것이 Spring MVC임.  
Servlet/JSP가 동작하려면 Web Application Server(WAS)가 필요함.  
우리가 Servlet/JSP 또는 Spring MVC로 만드는것을 ‘웹 어플리케이션’이라고 부를것임.  
웹 어플리케이션을 실행해주는게 WAS. WAS가 없으면 웹어플리케이션을 실행할 수 없음.

만약 PDF를  보려면 PDF 뷰어가 필요한것처럼 웹 어플리케이션을 실행하려면 WAS가 필요하다고 이해하면 됨.

WAS는 여러 구성 요소의 집합이다.
WAS를 정의하는 스펙이 있고 그 스펙을 구현하는 회사들은 여러 곳이 있다.  
(IBM, Oracle 등등..)  
가장 많이 쓰는것은 무료인 ’Tomcat’이다.   대신에 상용 WAS일수록 기능이 다양하다.  
WAS는 웹서버 기능을 내장하고 있다.  
웹서버는 정적인 페이지를 처리하는 성격이 강한 반면
WAS는 동적인 페이지를 처리하는 성격이 강하다.   
(웹서버도 동적인 페이지를 다룰 수 있긴 함..)

**웹서버란 무엇인가? WAS란 무엇인가? 찾아보자.**  
**web.xml이란?**  
**Web Application 구조**  

에 대해 공부하자.

WAS라는것도 보통은 자바로 만들어진 프로그램임.  
따라서 WAS를 실행하려면 JDK(JVM)가 설치되어있어야 함.

웹 어플리케이션 작성 -> JVM -> WAS에서 실행   
-> 작성한 웹 어플리케이션을 WAS에서 실행시키는것을 ‘배포(deploy)’ 라고 한다.

*하나의 WAS는 여러개의 웹 어플리케이션을 실행할 수 있다*

---

## Web Application의 구조 , 배포(deploy)
```
폴더 — WEB-INF — web.xml (서블릿스펙 3.0이상에서는 없어도 된다.) 
                        : 웹어플리케이션 배포를 위한 설정파일  
    — lib : 해당 웹 어플리케이션에서 사용하는 jar 파일  
    — classes : 우리가 작성한 java class 등이 놓여지는 폴더  
    — 다양한 폴더, jsp   
    — 각종 폴더, 파일(jsp, html, css, js, 등등..)  
위의 폴더가 webapps 폴더에 있으면, Tomcat이 실행할 때 자동으로 실행한다. 
```
보통은 위의 폴더 아래의 내용을 jar라는 명령으로 묶는다.  
확장자를 war이라는 파일로 만들어서 배포를 한다.

ex> 폴더 이름이 board라고 하면, board 폴더 아래의 내용을  
 board.war 라는 파일로 압축을 한다.   
 해당 파일을 webapps 폴더에 복사를 하면,   
 Tomcat이 실행될 때 자동으로 압축을 해제하고 실행한다.

그 외의 방법으로, tomcat의 manager를 이용하여 war파일을 배포할 수 있다.

---
## Tomcat

> http://tomcat.apache.org/ 에서 톰캣 다운로드 후 설치.

tomcat 설치폴더 - bin : tomcat 실행과 관련된 파일들이 있다.

tomcat 실행 : startup.bat(Windows) / startup.sh(Mac)

만약 mac 사용자가 tar.zg 파일이 아니라 zip파일을 받아서 압축을 풀고 사용한다면   
파일 퍼미션이 없다.  
-> 왜 그런지 linux의 퍼미션에 대한 내용에 대해 공부해서 알아보자.


startup.sh, startup.bat를 실행한 후,  
http://localhost:8080 이라고 하면 webapps/ROOT 라고 되어있는  
웹애플리케이션의 결과가 보여진다.

>http://localhost:8080/index.jsp 를 입력해보자.  
>http://localhost:8080/ 을 입력해보자.

위 요청을 하면
http 프로토콜의 요청라인에는 GET / 을 요청하게 된다.

WAS는 / 요청을 받으면 welcome-page를 찾아서 보여준다.  
welcome-page는 기본적으로 index.html, index.jsp가 된다.
(web.xml 에서 다르게 설정할 수 있다.)

http://localhost:8080/examples/

위의 경로는 /webapps/examples 아래의 index.html, index.jsp를 보여준다.

[JSP Examples](http://localhost:8080/examples/jsp/)
위 경로는 /webapps/exaples 아래의 jsp폴더에서 index.html, index.jsp를 보여준다.

http://localhost:8080/examples/jsp/jsp2/el/basic-arithmetic.jsp
examples가 context path ,
/jsp/jsp2/el/basic-arithmetic.jsp가 path.
그 뒤로 파라미터가 나올 수 있다.

URL 주소의 형식:
_http[s]://ip:port/ {context path} / path [?] 파라미터들_

파라미터들 : 이름=값&이름=값… 의 형태로 되어있다.

ROOT는 특수해서 context path에 값이 없이 비어보임.

보통 하나의 리소스, Servlet, JSP가 URL호출시 사용된다.
쉽게 설명하자면, URL주소가 10개 사용된다면 리소스, Servlet, JSP가 10개 있다.

---
https://raysoda.com/
https://raysoda.com/home51382
https://raysoda.com/home51382?gt=962715
https://raysoda.com/home51382?lt=962727

https://raysoda.com/ess
-> context path를 따로 할당해준 케이스

https://raysoda.com/home114873
사진들을 페이지에 쭉 보여주는 프로그램.

context path : “” <- 레이소다는 context path가 없다.
path /home51382 : path의 일정 부분이 변수처럼 사용 PathVariable

https://raysoda.com/images/962969
https://raysoda.com/images/962957
사진을 보여주는 프로그램.
path : /images/{사진id} <- PathVariable임.

Web Application은 여러 프로그램들의 모음이다.

::웹개발할때는 URL설계를 잘 해야 함. URL에 대한 고민을 안하면 어떤 프로그램을 만들게될지 알기 힘들다.::

http://www.inven.co.kr/board/wow/5280
http://www.inven.co.kr/board/wow/5280?sort=PID&p=1
http://www.inven.co.kr/board/wow/5280?sort=PID&p=2
http://www.inven.co.kr/board/wow/2081

http://www.inven.co.kr/board/wow/5280/6909

>게시판 목록보기 : /board/{게임 id}/{게시판 id} <- PathVariable
>게시판 상세보기 : /board/{game id}/{게시판 id}/{게시물 id}

```
글 쓰기 폼 : …… [확인]
글 쓰기 : …… 글 저장 -> (자동 이동) -> 게시판 목록 보기
					{redirect}  : 자동이동을 전문용어로 리다이렉트라고 한다.
```
이번주에는 데이터베이스가 아니라  
메모리에 올라가는 심플한 게시판을 만들어볼 예정.

>인벤(inven.co.kr)의 게시판 기능 누르면서 url이 어떻게 바뀌는지 살펴보고 파라미터값이 무엇일지 예상해보기.


## 게시판 프로토타이핑
회원가입 없이 게시판 글 쓸때 이름, 비번, 제목 입력하는 형식   
/ 댓글달기 만들고싶으면 만들고.. 

```
— 게시판 목록보기 페이지
	글번호 / 제목 / 작성자 / 작성 시간 / 이전 페이지 / 이후 페이지 / 페이지번호 / 
	* path : /list 라는 path를 만들겠다,
	* 파라미터 : 페이지를 구분하기 위해서 p라는 값을 만들겠다. p는 양의 정수가 온다.
```
```
— 게시글 상세보기 페이지
	* path는 무엇이고 
	* 넘겨받는 파라미터는 무엇인지 
```
꼼꼼하게 적어보기.

로직 -> 검색 기본 : 검색어 없으면 모든 목록을 가지고 온다.  
제목으로 검색하면 제목에 포함되어있는 글들을 가져온다.  
이런식으로 로직을 적어주어야 함.

**오늘의 숙제 : 미니 게시판을 프로토타이핑하고 Bootstrap을 이용해서 html , css 만들기**























