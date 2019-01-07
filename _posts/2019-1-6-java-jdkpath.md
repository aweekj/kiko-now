---
layout: post
title: JDK 환경변수 설정하기(macOS)
tags:
  - Java
  - post
---

JDK를 설치한 뒤 반드시 환경변수를 설정해야 한다.

그렇지 않으면 자바 가상 머신(JVM)을 실행할 수 없다.

환경변수는 JAVA_HOME, PATH, CLASSPATH의 세 가지 이다.


macOS에서 환경변수를 설정하기 위해 Terminal에서 아래 순서대로 진행한다.

>1) 설치된 JDK 목록 확인
>cd /Library/Java/JavaVirtualMachines/

>2) JAVA_HOME 경로 확인
>/Library/Java/JavaVirtualMachines/jdk1.8.0_191.jdk/Contents/Home

>3) 환경변수 설정을 위한 vi 실행
>vi ~/.bash_profile
>또는
>sudo vi /etc/profile
>을 입력하여 vi를 실행한다.

>4) 환경변수 설정
>3에서 vi가 실행되면 i를 눌러 insert모드로 변경한 후 아래 3가지 설정을 입력한다.
>export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_191.jdk/Contents/Home
>export CLASSPATH=.:$JAVA_HOME/lib/tools.jar
>export PATH=$PATH:$JAVA_HOME/bin
>3줄 모두 입력했으면 esc를 눌러 inesert모드를 빠져나온 뒤
>:wq를 입력하여 저장 후 vi를 종료한다.

>5) 터미널 종료 후 재실행
>vi 종료 후 터미널로 빠져나오면 exit을 입력하여 터미널을 종료하고 터미널을 재실행한다

>6) 설정 완료 확인
>모든 설정을 완료했기 때문에 터미널에서
>java -version
>을 입력하면 현재 자바 버전이 나온다.

위의 과정을 거쳐 정상적으로 환경변수를 모두 설정했다면 컴파일과 자바 가상 머신 실행이 가능해진다.