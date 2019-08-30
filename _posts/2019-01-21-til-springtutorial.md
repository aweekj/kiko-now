---
layout: post
title: 스프링 튜토리얼(1) 
tags:
  - TIL/Java
---

Today I Learned

TIL 2019-01-21

### 무엇이 개발자를 괴롭히는가?
* 수천라인의 코드
* 고구마 줄기처럼 파도파도 끝이 없는 코드들
* 같은 기능의 개발
* 유지보수

### 개발자의 고민
* 좀 더 나은 코드
* 좀 더 나은 성능

### EJB? 
과거의 스프링같은 존재…’겨울’ 그 자체. 자바개발자의 힘들었던 시기.  
장점 : 선언적 트랜잭션 관리 / 분산 컴포넌트   
단점 : 무거움. 분산 컴포넌트 자체의 불안정함(컴퓨터 3대 연결했는데 한대 고장나면 전부 안됨.)

### 스프링 프레임워크
오래된 인프라든 최신 인프라든 구애받지 않고  
최신 프로그래밍 사상과 기법을 활용해서 개발할 수 있게 만들어짐.  
-> 오래동안 꾸준한 버전업.

### 개발자 커뮤니티의 중요성
다양한 개발자 커뮤니티에 참여하도록 노력할 것.  
스터디든, 세미나든, 커뮤니티 행사든 나가서 정보를 획득할 것.  

~~사람은 소주같으면 안된다. 맥주같아야 한다. 70의 실력과 30의 거품이 필요하다.~~


## 스프링 코어(DI,AOP)
스프링도 선언적 트랜잭션..  
성공시 커밋, 예외 발생시 롤백 등의 내용을 자동으로 메소드에 끼워넣어줌.  
인스턴스 관리를 스프링이 해준다.  
* 컨테이너는 인스턴스의 생명주기를 관리한다.
* 생성된 인스턴드슫ㄹ에게 추가적인 기능을 제공한다.

> 컨테이너가 대신 관리해주는 인스턴스 = BEAN !

BEAN을 내가 관리하는게 아니라 컨테이너가 대신 관리한다는것은  
관리할 대상을 컨테이너에게 알려주어야 함.  
스프링한테 DAO나 SERVICE 인스턴스 만들어달라고 하면 만들어줌.  

---

`ApplicationContext` - 스프링 빈 컨테이너  

`AnnotationConfigApplicationContext`
	— Java Config 를 사용.  
  (java class가 설정파일이다.)  

`ClassPathXmlApplicationContext`
	— xml 파일을 설정파일로 사용한다.

요즘의 대세는 Java Config을 사용하는  
AnnotationConfigApplicationContext임.  
그러나 현장에서 xml을 사용할 수도 있으니   
ClassPathXmlApplicationContext도 봐둬야 함.

우리는 ClassPathXmlApplicationContext를 먼저 볼 것임.

우리 예제의 config 폴더의 아래 폴더들을 한번씩은 봐야 함.
* xml 설정
* java config 설정
* xml + java config를 섞는 설정
* Component scan 설정

**오늘 내용의 핵심은 DI**  
**Dependency Injection, 의존성 주입.**

## XML문서 

xml문서는 일종의 데이터. data의 실질적인 표준.  

* eXtensive Markup Language. 확장가능한 마크업 언어
* tag이름이 컬럼명 처럼 정해져있지 않다. -> HTML태그
* 최소 한개의 요소(Element)를 가지고 있어야 한다.
*  XML문서의 요소 = 시작tag(속성을 포함할 수 있다.) + 내용 + 종료tag
* 내용이 없을 경우엔 종료 tag를 생략할 수 있다.  
예를 들면 `<baen />` 이런 식으로.
* 반드시 문법을 지켜야 함(문법을 지키지 않으면 데이터로서의 가치가 없으니까)

* XML문서를 정의하는 방법이 필요 (DTD, XML스키마)  
요즘은 스키마를 주로 사용.  
xml스키마를 읽을 수 있다는것은  
이 xml문서를 어떻게 작성하는지 알 수 있다는 것.

* XML문서끼리는 통합할 수 있다.  
  통합하려면 이 문서가 어디에 속한 문서인지를 알아야 하는데   
  이를 위해 ‘name space’를 사용하여 구분한다.  
  name space는 보통 URI 를 이용한다.  
  패키지명처럼 도메인명을 쓰기도 하는데 그럼 너무 길어지기때문에  
  대신 name space를 사용하는것.

* Spring xml 파일의 root element(맨 바깥쪽에 위치한 요소)는 `beans` 이다. 


`<bean id=“bean1” class=“soundsystem.MyBean”/>`  
-> MyBean 인스턴스를 만들어달라.  
(기본값은 싱글턴 : 메모리에 하나만 올라가는것)

`new Mybean` 을 컨테이너가 대신 해서 인스턴스를 만들어주는 역할

해당 인스턴스를 `bean1` 이라는 `id`로 사용하도록 하겠다는 뜻.

이 때, MyBean은 기본생성자가 반드시 있어야 한다.

---

`<bean id=“job1” class=“soundsystem.Job1”/>`  
Spring 컨테이너는 Job1 클래스에 대한 인스턴스를 생성한다.  
기본은 싱글턴으로 생성한다.

Spring이 제공하는 특수한 목적의 인터페이스들이 있다.  
대표적인 것이 **BeanNameAware**.

## 숙제
오늘 실시한 SpringExam01~04 보고 다시 공부하기.
