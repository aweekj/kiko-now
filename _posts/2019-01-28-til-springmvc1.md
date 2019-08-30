---
layout: post
title: Spring MVC(1)
tags:
  - TIL/Java
---

Today I Learned

TIL 2019-01-28

## Spring MVC
#### 서블릿 : web.xml or @WebServlet(서블릿 스펙 3.0 이상)  
- 서블릿은 PATH를 지정한다.
- URL을 처리.
#### JSP (View의 역할을 수행.)
- 되도록 JAVA 코드는 적지 말자.  
- JSTL & EL 사용.

서블릿과 JSP만 가지고 개발하기에는 여러 단점이 존재 -> 웹개발 프레임워크 등장!  

DefaultServlet : 정적인 페이지를 보여주는 기본 서블릿.  
서블릿 PATH을 지정하지 않으면 전부 디폴트서블릿이 처리해줌. / PATH

### DispatcherServlet   
URL PATH : / (슬래시를 PATH로 잡음.)

브라우저에서 DispatcherServlet으로 요청을 보낼 때 Accept 헤더에 text/html 과 같은 요청정보를 담아서 보냄.

즉 어떤 요청이 와도 모든 요청을 DispatcherServlet이 처리해줌. 
프론트 컨트롤러라고도 함.

이러한 패턴을 **Front Controller Pattern** 이라고 함.

### Controller
사용자는 ~~컨트롤러 라고 불리는 클래스들을 사용자가 만들게 된다.  
~~컨트롤러 클래스에는 여러 메소드가 있고,  
각각의 메소드에는 @RequestMapping이라는 애노테이션이 붙는다.  
컨트롤러 클래스에는 @Controller 애노테이션을 갖고있다.  
모든 컨트롤러는 사실 전부 @Component 애노테이션을 갖고있다.(컨트롤러도 컴포넌트다.)  

@RequestMapping에는 사용자의 URL PATH설정이 들어있다.(서블릿의 @WebServlet 역할)  
각 컨트롤러의 @requestMapping 메소드, 즉 컨트롤러의 메소드를 **'Handler'** 라고 부른다.

HandlerMapping에는 어떤 URL PATH를 어떤 Controler가 관리하는지를 저장한다.

디스패쳐서블릿은 핸들러매핑을 이용해서 찾은 정보로 HandlerAdpoter라는 클래스 위에서 Controler의 메소드(핸들러)를 실행한다.

컨트롤러의 메소드 하나하나가 서블릿의 서비스메소드와 유사하다고 생각하면 됨.

컨트롤러에는 서비스메소드가 여러 개 있다.

핸들러어댑터 위에서 실행된 컨트롤러 메소드는 View Name을 리턴한다.

뷰 네임이 리턴되면 Dispatcher Servlet은 View Resolver를 여러 개 가질 수 있는데 이 중에서 알맞은 View Resolver를 선택한다.

View Resolver는 뷰 네임의 정보를 이용해서 객체를 만들기때문에 '전략객체' 라고도 불리운다.

선택하면 View Resolver에 의해서 View라는 객체가 생성된다.

View가 생성이 되면 그 결과를 브라우저로 응답해서 출력된다.

---

서블릿에서 값을 리퀘스트 객체에 담아서 JSP에 전달하면 JSP가 그 결과를 출력함. JSP가 View의 역할을 수행.

View가 꼭 JSP가 아니더라도 다른것도 View의 역할을 할 수 있다.

View 기술은 다양하다. JSP만 HTML을 보여주는 게 아니라. HTML을 보여줄 수 있는 기술은 굉장히 다양하다.

디스패쳐 서블릿을 잘 이해해야 스프링MVC를 잘 이해할 수 있다.

---

웹어플리케이션 -> 배포 -> Tomcat(WAS)
### 1) web.xml
DispatcherServlet (path : /)  
-> 읽어들일 파일도 설정 (xml or java config)
-> 내부적으로 ApplicationContext를 가진다.
-> 위의 ApplicationContext는 ContextLoaderListener의 ApplicationContext를 부모로 가진다.
-> 웹과 관련

ContextLoaderListener
-> 읽어들일 파일을 설정 (xml or java config)
-> 내부적으로 ApplicationContext(스프링 컨테이너) 를 가지고 있다.
-> Service, Repository 등의 비지니스와 관련

>web.xml은 디스패쳐서블릿이랑 컨텍스트로더리스너 두개로 설정함.
웹관련된부분과 비지니스와 관련된 부분으로 나눠서 설정하겠다. 이말이다.

>getBean을 하면 부모의 ApplicationContext에서 먼저 찾고 그 다음 자신의 ApplicationContext를 찾는다.

> 서비스에서는 컨트롤러 사용할 수 있는데, 컨트롤러에서는 서비스를 사용할 수 없다.

`숙제 : 직접 web.xml 파일 설정해보기`

### 2) ServletContainerInitializer 를 구현하는 클래스를 작성하여 설정.(Servlet 스펙 3.0 이상)
web.xml이 없으면 ServletContainerInitializer구현 클래스를 찾아서 작성

### 3_ WebApplicationInitializer(스프링이 갖고있는/제공하는  ServletContainerInitializer)를 구현

---

 
