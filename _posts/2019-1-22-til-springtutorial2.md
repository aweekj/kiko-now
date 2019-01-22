---
layout: post
title: TIL 2019-01-22
tags:
  - TIL
---

Today I Learned

TIL 2019-01-22

## Java Config 개념 익히기

스프링은 아래의 기술을 적극적으로 사용한다.  

java의 리플렉션이란 기술을 이용하면 interface를 구현하는 인스턴스를 동적으로   
생성할 수 있다. — Java Proxy   

java 기본으로 제공하는 기술로는 특정 클래스를 상속받는 인스턴스를 동적으로   
생성할 수 없다. — 오픈소스로 가능. 대표적인 프로젝트는 **cglib**  
컴파일하지않고도 바이트 코드를 동적으로 생성하는 기술.

인터페이스에 대한 인스턴스 자동생성은 java 리플렉션으로 가능하지만
특정 클래스를 상속받는 인스턴스를 동적으로 생성하려면 cglib같은게 필요함..

Spring이 (정확히는 Spring Container가) java config를 읽어들이면,  
해당 java config 클래스를 상속받는 객체를 동적으로 생성한다.  
(상속받는 객체가 자동으로 만들어지는 개념)

예를 들면,
```
class DiceConfig$$EnhancerBySpringCGLIB$$2b1a2b2f 
        extends DiceConfig{
    @Bean
    public Dice dice(){
        // 처음호출되었느냐? 아니냐?
        // 처음호출되었을 경우엔 
        return super.dice();
        // 처음이 아닐 경우 
        // id가 Dice가 이미 저장되어 있으니 해당 dice를 리턴.
    }
```

왜 동적으로 생성하느냐?

Config는 자바 문법을 쓰지만 모든 자바 문법을 자유롭게 쓸 수는 없다.  
대표적으로 메소드 오버로딩을 할 수 없다(메소드명이 id로 유니크하게 쓰이기 때문이다)

> *DiceConfig.java에서 Dice dice() 메소드가 한번만 출력되는 이유는?*

---

* xml config  //xml에서 bean 태그를 사용하는 형태
* java config //@bean 을 사용하는 형태
* @ComponentScan(basePackages = "soundsystem.book")
  - @Component 이 붙은 클래스를 찾아서 인스턴스로 등록한다.
  - soundesystem.book 패키지 이하에서 클래스를 찾는다.
  - @Controller, @restController
  - @Service, @Repository, @Configuration ......
  
@Component가 붙은 클래스에 @Autowired 가 붙은 필드가 있다면,
Bean을 주입한다.
@Autowired 말고도 유사한 어노테이션들이 있다.

---

  ### 해봅시다.
* HikariCP를 xml로 설정하여 사용.
* HikariCP를 Java Config를 이용하여 사용.


spEL 표현식 <--- 오늘 공부하기  

https://jijs.tistory.com/entry/spring-%EC%84%A4%EC%A0%95-xml%EA%B3%BC-%EC%86%8C%EC%8A%A4%EC%BD%94%EB%93%9C%EC%97%90%EC%84%9C-properties-%EC%82%AC%EC%9A%A9%ED%95%98%EA%B8%B0?category=2216


---

hikariconfig에서 값을 얻어서 DataSourceConfig에 값을 넘겨줌.

Spring에서 데이터베이스 프로그래밍을 하려면
DataSource와 PlatformTransactionManager를 구현해야 한다.
