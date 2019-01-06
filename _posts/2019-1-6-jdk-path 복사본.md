---
layout: post
title: Maven을 이용한 JUnit 환경설정
tags:
  - Java
  - post
---
Maven을 이용하여 Testing Framework인 JUnit을 간단하게 추가할 수 있다.

```
    <dependencies>

        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
            <scope>test</scope>
        </dependency>

    </dependencies>
```

Maven 프로젝트의 pom.xml에 위 dependency를 추가한다.