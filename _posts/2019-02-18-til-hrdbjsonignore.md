---
layout: post 
title: REST?
tags:
  - TIL
---
 Today I Learned

TIL 2019-02-18

## REST?
https://meetup.toast.com/posts/92  

https://github.com/JaeYeopHan/Interview_Question_for_Beginner/tree/master/Development_common_sense#restful-api


---

RestController가 리턴하는 엔티티는 MessageConverter가 변환한다.  
json으로 변환하는 것은 내부적으로 Jackson이 사용된다.  

## Json Infinite Recursion 문제 해결.
https://spring.io/blog/2014/12/02/latest-jackson-integration-improvements-in-spring

제대로 알고 쓰자. 'jackson 사용법'을 공부해야한다.  

@JsonIgnore // json으로 변환 안된다.

@JsonManagedReference
데이터가 필요한 쪽에 붙여준다.

@JsonBackReference
반대편에서 계속 반복호출되는 것을 막는다.

jackson에서 사용하는 애노테이션들임..  
jackson 라이브러리에서 제공한다. 스프링과 전혀 상관없이. 그래서 jackson 사용법에 대해 알아야 한다. 

Json 변환은 우리가 ObjectMapper로 수동으로 해봤음.  
잭슨 라이브러리도 ObjectMapper를 이용함.  

--- 

hibernate = JPA 구현체.  
Thymeleaf = view 역할.  
viewName이 리턴되면 그이름으로 뷰를 불러오는데  
이때 thymeleaf 템플릿이 사용된다.  

RestController -> 객체(=View) -> JSON

RestController가 객체를 리턴하는데 이게 뷰다. 

Client -> RestControll

1)
클라이언트가 레스트컨트롤러 호출하고 레스트컨트롤러가 서비스를  
호출하면 엔티티 객체가 리턴된다. 이 엔티티객체를 지금은  
DispatcherServlet가 MessageConverter가 Json으로  
변환해서 클라이언트에게 전달했음. 보안상 문제가 될 수 있음.  
사용자에게 전하지 말아야 할 데이터까지 json으로 변환될 수 있음..  
@JsonIgnore를 적절히 사용해야 하는 문제.

2)
이 엔티티객체에서 필요한 정보만 꺼내서 DTO에 담아줌.  
DTO는 엔티티가 아니다.  
이제 DTO가 JSON으로 바뀌어서 클라이언트에게 가게 됨.  
이 경우에는 DTO가 뷰가 된다.

두가지 방법이 충돌이 나는데 지금처럼 엔티티를 직접 변환해서  
json으로 바뀔 땐 사용자에게 전하지 말아야 될 데이터까지   
Json으로 변환될 수 있음. 이 때 사용하는게 @JsonIgnore..

OSiV..체크

---

프로그래밍?  
'쇼핑몰의 웹 앱을 만들겠다' 라고 한다면 다양한 이해당사자가 있다.  
다양한 이해당사자로 빙의가 되어야 함 ㅋㅋ 일종의 롤 게임.  
개발자의 역할을 수행해야 할 떄도 있고 PM의 역할을 수행할 수도 있고 운영자의 역할을 수행해야 할 때도 있을 것임.  
개발만 이야기해서는 안되고 각각의 입장에 대해 생각해봐야 함.  
프로그래밍을 하겠다! 라고 한다면 '주제' 를 정하고, 무엇을 하겠다는 주제가 정해지면 '레퍼런스 아키텍쳐'에 대해 봐야 함.  
해당 '도메인'의 비즈니스가 있으면 그와 유사한 사이트를 찾아본다.  그 유사한 사이트가 어떤 아키텍쳐로 만들어졌는지 조사할 필요가 있음.  
-> 조사 결과에서 추가할 건 추가하고 뺄 건 빼서 '아키텍처'를 구축해야 함.  

요구사항에는 크게 두가지가 있음.  
1. 기능적 요구사항 : (일반적인 기능)
2. 비 기능적 요구사항 : 품질,성능,확장성,트래픽 처리량 등등과 관련된 요구사항. 

아키텍쳐는 비 기능적 요구사항에 관련이 깊다.  
아키텍쳐는 그림 한장정도로 표시할 수 있으면 좋다.  
우리의 프로젝트도 어떤 아키텍쳐를 사용할까,  
아키텍쳐를 사용한다면 기술 정의가 필요함 : 예) JPA vs MyBatis / 이 기술을 쓰는 이유가 명확하게 말할 수 있어야 함. 다양한 입장을 종합적으로 고려 한 기술 선택, 정의가 필요함.  

-> 기능 정의(유스케이스, 스토리 방식 등등)
-> 개발환경설정(IDE, 협업툴..github를 쓸거냐 어떤 기능까지 쓸꺼냐..)
-> 배포와 관련된 고민.(AWS, Azure, 데이터센터 입주 등..) 배포 자동화는 어떻게 할꺼냐..? Docker:개발환경과 배포환경을 일치시켜줌.  
이런걸 다 할 수 있는 사람을 DevOps라고 부름.  개발 운영 다 하는사람.  
협업툴은 '협업을 하고자 하는 마음을 가진 사람' 이 잘 쓴다. 아무리 좋은 툴을 써도 '안'하는 사람이 있기 마련임.  
협업을 잘 하려면 능동적으로 도구를 찾아서 쓰게 됨.    
능동적이고 유연한 사고를 가지려고 노력해야 함..  


