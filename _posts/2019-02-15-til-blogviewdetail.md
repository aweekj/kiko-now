---
layout: post 
title: TIL 2019-02-15
tags:
  - TIL
---
 
# web api 기초

1. post방식에서 csrf끄는 방법  
`and().csrf().ignoringAntMatchers("/**");`  
mysql distinct 사용 이유?

ToString 잘못 사용하면 Lazy Loading의   
무한재귀가 일어날 수 있으므로 주의.  
->해결방법 @JsonIgnore 


2. XML 메시지 컨버터 빈이 추가되려면 다음의 라이브러리를 추가한다.  
```
    <!-- jackson에서 xml처리 라이브러리 -->
    <dependency>
        <groupId>com.fasterxml.jackson.dataformat</groupId>
        <artifactId>jackson-dataformat-xml</artifactId>
    </dependency>
```

3. 테스트를 위한 RestController를 만든다.  
```
package my.examples.blog.controller.api;

import my.examples.blog.domain.Comment;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/comments")
public class CommentApiController {
    @PostMapping
    public Comment addComment(@RequestBody Comment comment){
        comment.setId(100L);
        return comment;
    }
    @GetMapping
    public List<Comment> getComments(){
        List<Comment> list = new ArrayList<>();
        Comment commnet = new Comment();
        commnet.setName("kim");
        commnet.setPasswd("1234");
        commnet.setContent("hello");
        list.add(commnet);

        Comment commnet2 = new Comment();
        commnet2.setName("kim");
        commnet2.setPasswd("1234");
        commnet2.setContent("hello");
        list.add(commnet2);

        return list;
    }
}
```

 ---

이제 슬슬 정하자..!  
> 무슨 프로젝트를 할 것인가?  
> 누구와 할 것인가?  
> 혼자 하지 말 것! 2~3인이 적당함.
