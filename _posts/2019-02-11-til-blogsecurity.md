---
layout: post 
title: Spring Security
tags:
  - TIL
---

Today I Learned

TIL 2019-02-11

Spring Web MVC

자동으로 Bean으로 등록된다.  
DispatcherServlet  
ViewResolver(spring-boot-starter-thymeleaf)를 추가하여 타임리프를 사용할 수 있도록 한다.
...

```
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-web</artifactId>
</dependency>
    <dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>

```

화두 : Service 인터페이스 반드시 필요한가?  
서비스는 일종의 규약이다. '~~한 기능이 필요하다' 라고 할 때   구현보다 설계가 우선되기 때문에 필요한 기능을 먼저 정의해두고   하나씩 구현해나가야 이치에 맞기 때문에 인터페이스를 사용한다?  
인터페이스를 반드시 사용해야 하는건 아니지만 반드시 나만의   논리를 갖추어야 한다.

Spring DATA Jpa

DataSource (Hikari CP)   
PlatformTransactionManager  
EntityManager  

```
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>

<dependency>
  <groupId>mysql</groupId>
  <artifactId>mysql-connector-java</artifactId>
  <version>5.1.47</version>
</dependency>

<dependency>
  <groupId>com.h2database</groupId>
  <artifactId>h2</artifactId>
  <version>1.4.197</version>
  <scope>test</scope>
</dependency>
```


컨트롤러에서 레파지토리를 바로 사용하면 왜 안될까?  
코드의 중복이 생기기 때문.  
다른 코드에서 컨트롤러를 이용하려면 객체를 새로 생성해야 하니 코드의 중복이 일어난다.  
'Service'는 왜 필요할까? 질문해보기.  

어떤 순서로 개발을 해야 할까?  

Web & JPA를 함께 사용하면  
OSiV 패턴이 적용된다.(Open Session in View 패턴)  
사용하고싶지 않다면?  
spring.jpa.open-in-view=false  
요걸 하면 뷰단이랑 컨트롤단에서 레이지로딩이 되지 않음.  

--- 

JPA 관계와 관련된 Annotation

### lazy loading을 하려면 트랜잭션 안에서만 가능하다.
ex> Employee e = employeeRepository.getEmployee(1L);  
Job job = e.getJob(); // select * from job where id = ?  
**JPA Entity 생명주기**

@OneToOne  : Default FetchType.EAGER  
@OneToMany  : Default FetchType.LAZY  
@ManyToOne : Default FetchType.EAGER  
@ManyToMany : Default FetchType.LAZY  

JPQL : SELECT e FROM Employee e
LAZY는 사용할 때마다 쿼리 실행, EAGER는 기본적으로 사용하던 안하던 쿼리 다 실행. 그러나 EAGER는 쿼리 성능 문제로 되도록 사용 안하는게 좋음.  
뒤가 One로 끝나는것들은 디폴트가 Eagar 로 돼있음..

**1 + n 문제 : http://wonwoo.ml/index.php/post/975**  
해결하려면?  
1) fetch join (가장 많이 쓰는 방법. 연습 많이 해야 함.)
2) @BatchSize(size = 5)
3) @Fetch(FetchMode.SUBSELECT)

---

## 보안 (Spring Security)
***인증** 과 **인가**의 차이 알아두기.*

인증은 로그인, 인가는 관리자페이지 접속 권한으로 비유.  

스프링 시큐리티에서 필터를 제공함(10개 이상..되게 많음)  
```
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

위의 starter를 추가하고 웹 애플리케이션을 실행하면 다음과 같은 로그가 출력

메모리에 회원이 하나 자동생성됨.  
id : user  
Using generated security password로 자동 생성됨.  

UserDetailService 라는 인터페이스  

인증을 처리하는 Spring Security 필터는 내부적으로  
UserDetailsService를 구현하는 Bean을 사용하여 아이디  암호가 일치하는지 검사한다.  
UserDeatilsSErvice를 구현하는 기본 객체가 내부적으로  
user정보를 가진다.  
```
UserDetails loadUserByUsername(java.lang.String username) throws UsernameNotFoundException
```

UserDetails객체에는 아이디, 암호, 권한정보가 들어가있음.  


@Service가 아니라 @Component 애노테이션이 붙는 이유.  
서비스가 아니라 필터이기 때문.  

pom.xml 파일에 필요한 라이브러리 추가  

웹 애플리케이션 실행. user랑 자동생성된 암호로 로그인

 UserDetailsService를 구현하고 있는 객체
 UserDetails를 구현하는 객체

 << 인증에 대한 설정 >>

 인가에 대한 설정..은 아직 안했다.
