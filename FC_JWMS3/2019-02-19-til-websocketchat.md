---
layout: post 
title: Websocket 채팅
tags:
  - TIL/Java
---
Websocket을 이용한 채팅만들기

1. pom.xml 에 라이브러리를 추가한다.
  - 채팅, 푸시알림 등을 받으려면 지속적인 연결이 필요하다. 이때 사용하는 기술이 websocket
  - websocket을 지원안하는 브라우저가 있다. websocket을 지원안하는 브라우저를 위한 기술이 필요하다.
  - sockjs(스프링이 지원), socket.io 와 같은 라이브러리가 있다.

```
  <!-- websocket -->
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-websocket</artifactId>
  </dependency>

  <!-- 프론트단에서 사용하는 sockjs 라이브러리 -->
  <dependency>
    <groupId>org.webjars</groupId>
    <artifactId>sockjs-client</artifactId>
    <version>1.0.2</version>
  </dependency>
```

2. websocket을 사용하려면 몇가지 설정이 필요하다.
  로그인을 한 사용자만 채팅을 하도록 할 예정.
  /chatrooms
  /ws <--웹 소켓 엔드포인트 URL (웹소켓은 브라우저가 http로 요청을 보낸 후, 서버가 웹소켓을 지원해주면 웹 소켓연결로 바뀐다.)

  
  채팅 구축 keyword : Spring Boot & Redis & Pub/Sub  

3. 다음의 클래스와 파일을 작성한다.  
설명은 주석을 참고  
WebSocketConfig  
ChatMessage  
ChatSocketHandler  
ChatController  
chatrooms.js  
chatrooms.html  

