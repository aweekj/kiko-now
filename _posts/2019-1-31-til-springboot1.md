---
layout: post
title: TIL 2019-01-31
tags:
  - TIL
---

Today I Learned

TIL 2019-01-31

https://start.spring.io

Spring boot 프로젝트를 시작할 수 있다.

Group : my.examples
Artifact : shop
Dependencies : Devtools, web, lombok, thymeleaf

프로젝트 생성 버튼을 누르면 파일이 다운로드. 
압축을 해제.

---

스프링 부트는 내장 톰켓을 가지고 있다. 톰켓을 설치할 필요가 없다.
이 내장 톰켓은 기본적으로 jsp 를 지원하지 않는다.
스프링 쪽에서 지원하는 뷰기술은 thymeleaf 이다.

jsp를 사용하고 싶으면 별도의 starter를 추가해야한다.
```
		<dependency>
			<groupId>javax.servlet</groupId>
			<artifactId>jstl</artifactId>
		</dependency>
		<dependency>
			<groupId>org.apache.tomcat.embed</groupId>
			<artifactId>tomcat-embed-jasper</artifactId>
		</dependency>
```

### JSP에서 왜 자바코드를 사용하면 안될까?
Spring boot 의 Starter라는 것은 라이브러리나 프레임워크의 모음 + 자동 설정.

resources / templates 에 index.html 파일을 만든다.
```
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <title>Hello Spring Boot!</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>

<body>

<h1>Hello Spring Boot <span th:text="${name}"></span></h1>

</body>

</html>
```
my.examples.blog.controller package를 만든다.
해당 package아래에 MainController를 만든다.

```
package my.examples.blog.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.ㅍbind.annotation.GetMapping;

@Controller
public class MainController {
    @GetMapping("/main")
    public String main(Model model){
        model.addAttribute("name", "urstory");
        return "index";
    }
}
```

---

실행은 main메소드가 있는 BootApplication(자동생성)을 실행한다.  
소스코드가 수정되면 Build - Build Project를 하면 서버를 재시작하지 않고 반영가능하다.

---

Model에 값을 저장 --> Thymeleaf 템플릿 (그 결과를 출력.)
타임리프 템플릿 이용해서 결과를 추월하는 방법

** Maven을 설치한다. path설정을 한다.  
 콘솔창에서 maven을 실행할 수 있도록 한다.   
** AWS 계정을 생성한다. 무료 ec2를 생성한다.    
** ec2에 JDK 8 (openJDK or OracleJDK)를 설치한다.   
** ec2에 git을 설치한다.    
** ec2에 maven을 설치한다.    

---

Spring JDBC 프로그래밍을 하고 싶다면?
1. pom.xml 파일에 다음을 추가

```
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-jdbc</artifactId>
</dependency>

<dependency>
  <groupId>mysql</groupId>
  <artifactId>mysql-connector-java</artifactId>
  <version>5.1.47</version>
</dependency>
```

2. application.properties에 다음을 설정한다.
```
spring.datasource.url=jdbc:mysql://localhost:3306/connectdb?useUnicode=true&characterEncoding=UTF-8
spring.datasource.username=connect
spring.datasource.password=connect
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
```

3. 다음의 객체를 주입받아 DAO를 만든다.
```
@Autowired
NamedParameterJdbcTemplate jdbc;
```