---
layout: post 
title: TIL 2019-02-21
tags:
  - TIL
---
 Today I Learned

TIL 2019-02-21

https://docs.docker.com/  

docker vs hypervisor(VM : 가상머신) 

가상머신 -> VMWare, Parallels, VirtualBox, Hyper-V(windows)

https://medium.com/@darkrasid/docker%EC%99%80-vm-d95d60e56fdd  

'docker 장점' 같은거 검색해보기.

---

학습효과가 높아지는 방법 중 하나는, 무언가를 **설명하듯이** 공부해야 한다는 것.  
예를 들면 오늘 공부한 도커가 뭔지 다른사람에게 설명할 수 있어야 한다.  

---

실제 개발환경과 배포환경이 다른 경우. 잘 동작이 안될 수 있다.  
개발환경과 배포환경을 일치시켜야 하는 문제 -> docker가 해결!

---
https://hub.docker.com/ 에 가서 로그인 (회원가입안되어 있으면 회원가입한다.)  

docker version  
docker info  
docker run hello-world // 로컬에 이미지가 없을 경우 다운받아서 실행한다.  

docker images // 로컬의 이미지 목록을 보여준다.  
docker image ls  

docker ps // 현재 실행중인 컨테이너  

docker ps -a // 종료된 컨테이너 정보도 보여진다.  
docker container ls --all  

---

mkdir /tmp/docker_study/exam01   

/tmp/docker_study/exam01 폴더에서 Dockerfile 을 만든다.  

```
# Use an official Python runtime as a parent image
FROM python:2.7-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]

```
같은 폴더에 requirements.txt 을 작성  
```
Flask
Redis
```

같은 폴더에 app.py 를 작성  
```
from flask import Flask
from redis import Redis, RedisError
import os
import socket

# Connect to Redis
redis = Redis(host="redis", db=0, socket_connect_timeout=2, socket_timeout=2)

app = Flask(__name__)

@app.route("/")
def hello():
    try:
        visits = redis.incr("counter")
    except RedisError:
        visits = "<i>cannot connect to Redis, counter disabled</i>"

    html = "<h3>Hello {name}!</h3>" \
           "<b>Hostname:</b> {hostname}<br/>" \
           "<b>Visits:</b> {visits}"
    return html.format(name=os.getenv("NAME", "world"), hostname=socket.gethostname(), visits=visits)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
```
같은 폴더 안에 다음의 파일이 있어야 한다.  
```
Dockerfile		app.py			requirements.txt
```
헌재 경로(.)에 있는 Dockerfile을 이용하여 이미지를 만든다.  
docker build --tag=friendlyhello .  

docker iamges  

내컴퓨터(Docker) ---> friendlyhello  
4000 80  

docker run -p 4000:80 friendlyhello  

ctrl + c 종료.  

참고문서 : https://www.popit.kr/%EA%B0%9C%EB%B0%9C%EC%9E%90%EA%B0%80-%EC%B2%98%EC%9D%8C-docker-%EC%A0%91%ED%95%A0%EB%95%8C-%EC%98%A4%EB%8A%94-%EB%A9%98%EB%B6%95-%EB%AA%87%EA%B0%80%EC%A7%80/

---

docker login

명령 예제
docker tag image username/repository:tag

docker 이미지 업로드

docker tag friendlyhello urstory/friendlyhello:part2
docker push urstory/friendlyhello:part2

docker가 깔려있다면 아래와 같이 실행
docker run -p 4000:80 urstory/friendlyhello:part2

---

docker-compose.yml
```
version: "3"
services:
  web:
    # replace username/repo:tag with your name and image details
    image: urstory/friendlyhello:part2
    deploy:
      replicas: 5
      resources:
        limits:
          cpus: "0.1"
          memory: 50M
      restart_policy:
        condition: on-failure
    ports:
      - "4000:80"
    networks:
      - webnet
networks:
  webnet:
```
docker compose를 사용하려면 docker swarm을 사용한다.  

docker swarm init  

```
docker swarm join --token SWMTKN-1-0hbtxgg0swtc9rw4xz1frbg5ufi3tkobofmnq1upismy9o2j9u-dhbwi2oj15vm3bdmnvdfpp668 192.168.65.3:2377
```

getstartedlab 이름의 서비스가 실행된다.

docker stack deploy -c docker-compose.yml getstartedlab

실행되고 있는 서비스에 대한 정보는 아래의 명령으로 알 수 있다.

docker service ls

docker service ps getstartedlab_web

docker container ls -q

docker stack ps getstartedlab

docker-compose.yml을 수정후 다시 실행 (ex : replicas를 수정후 실행)
약간의 시간이 지난 후 변경되는 걸 확인할 수 있다.

docker stack deploy -c docker-compose.yml getstartedlab

서비스를 종료

docker stack rm getstartedlab

docker swarm 을 종료

docker swarm leave --force

---
가상머신을 생성한다.(Local VMs (Mac, Linux, Windows 7 and 8))  

https://www.virtualbox.org/wiki/Downloads 를 설치  

`docker-machine create --driver virtualbox myvm1`
`docker-machine create --driver virtualbox myvm2`

가상머신을 생성한다. (Local VMs (Windows 10/Hyper-V)  

`docker-machine create -d hyperv --hyperv-virtual-switch "myswitch" myvm1`
`docker-machine create -d hyperv --hyperv-virtual-switch "myswitch" myvm2`

mysql 의 경우 데이터가 저장되는데.... 이러한데이터는 컨테이너에 저장되면 안된다.

---



