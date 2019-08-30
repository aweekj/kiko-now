---
layout: post
title: 게시판 기능 
tags:
  - TIL/Java
---

Today I Learned

TIL 2019-01-17

### 게시판 기능 구현

답글의 답글을 달 때 ‘비용’의 제약이 발생한다.  
같은 계층 내에 새 답글이 달리면 비용이 많이 발생한다.  

알고리즘을 만들 때는 한계와 최악, 최선의 상황을 고려해야 함.  

회원정보에서 이름을 바꾸면 게시판에서도 바뀌게 해야 함.  


1. [The try-with-resources Statement  (The Java™ Tutorials > Essential Classes > Exceptions)](https://docs.oracle.com/javase/tutorial/essential/exceptions/tryResourceClose.html)

2. ps 빼고 리팩토링
try ( )~~~~ 안에 서 선언되면 자동으로 close된다.

3. SQL 다른 클래스로 빼내기

---

### 암호화 
암호화 하는 라이브러리를 추가할 예정.  
스프링이 제공하는 sequrity 모듈. (Maven dependency 추가)  
패스워드 인코더 / matechers 메소드 이용.  

UserJoinServlet.

* 게시판 글쓰기, 회원가입 
* 로그인 
* 로그인 세션
* 로그아웃

로그인이 필요한 곳은 세션을 이용해서 


---

### 세션(로그인..)
set Attribute(key,value) <- (String, Object)니까  
user 객체를 넣을 수도 있음.

‘EL 표기법을 사용하면 session을 가져올 수 있다’  
‘session 스코프에 유저라는 값이 있으면 유저의 이름을 보여주고 없으면  
로그인 버튼 보여주고..하는 식의 조건문을 쓸 수 있다.’


로그인해서 글쓸때 내이름 굳이 입력 안해도 됨.
쓴 내용 DB에 저장할 때 누구의 글일지를 세션으로부터 user id를 가져와서 board db에 insert 해야함.

---

*내일은 서블릿 필터를 추가할 예정*  
로그인 안해도 볼 수 있는 페이지와 로그인했을때만 볼 수 있는 페이지를 가려내는 기술.

---
```
freepost TABLE

id(PK)
title
nickname
content
regdate
read_count
fam_num
fam_lev
fam_seq
user_id(FK)
email(FK)
```
---
```
user TABLE

user_id(PK)
name (중복불가)
email (중복불가)
passwd
regdate
```
