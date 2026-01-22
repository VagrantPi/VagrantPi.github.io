---
layout: post
title: "Drone - Drone Pipeline 簡介"
tagline: "Drone Pipeline 簡介 - Drone CI/CD Pipeline 的基本概念、 Drone Pipeline 的作用、 Drone Pipeline 的優點"
description: "Drone Pipeline 是 Drone CI/CD 的核心，Drone Pipeline 簡介文章中，我們將簡單介紹 Drone Pipeline 的基本概念、 Drone Pipeline 的作用和優點，幫助您更好地理解 Drone CI/CD Pipeline"
author: VagrantPi
tags: Docker CI/CD Drone
imgurl-fb: /public/img/index/drone.jpg
imgurl: /public/img/index/drone.jpg
image: /public/img/index/drone.jpg
imgalt: drone-logo
---

## 前言

上次間單的過了一次 CI 的流程，這次會簡單的講解 Pipeline 裡面寫的東東

pipeline 基本上有下面幾個區塊所組成(依你的專案類型不同而不同):

- Workspace
- Clone
- Service
- Pipeline Step
  - Plugin

先來段範例吧:

```yaml
workspace:
  base: /go/src
  path: drone_test

clone:
  git:
    image: plugins/git
    tags: true

pipeline:
  test-db-init:
    image: mongo:4.0.2
    # secrets: [ MONGO_INITDB_ROOT_USERNAME,  MONGO_INITDB_ROOT_PASSWORD]
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=admin
      - MONGO_INITDB_DATABASE=drone_test
    commands:
      - sleep 5
      - mongo $MONGO_INITDB_DATABASE --host database --port 27017 -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase admin --eval "db.createUser({user:'$MONGO_INITDB_ROOT_USERNAME', pwd:'$MONGO_INITDB_ROOT_PASSWORD', roles:[{role:'root', db:'admin'},{role:'readWrite', db:'$MONGO_INITDB_DATABASE'}]});"
      - mongo --host database --port 27017 -u admin -p admin --authenticationDatabase drone_test
  test:
    image: golang
    environment:
      - TEST_TEST=test_environment
    commands:
      - echo $TEST_TEST
      - go test 
      - go test -v -cover -coverprofile coverage.out
  slack:
    image: plugins/slack
    channel: drone_test
    # secrets: [ slack_webhook ]
    webhook: https://hooks.slack.com/services/....
    when:
      status: [ success, failure ]

  codecov:
    image: robertstettner/drone-codecov
    token: ....
    files:
      - coverage.out
    when:
      event: [ push, pull_request ]
services:
  database:
    image: mongo:4.0.2
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=admin
      - MONGO_INITDB_DATABASE=MYDB
```

是不是很簡單？   有沒有覺得跟 docker-compose 有 87% 像

在說明之前有一件必須先知道的事，drone 是 based on docker 的，所以在每一個階段所做的事情，都需要使用一個 docker image 來裝

## Workspace

```yaml
workspace:
  base: /go/src
  path: drone_test
```

所有的 pipeline step 使用同一個 workspace，這邊其實等同於，最後專案都會在 /go/src/drone_test 中

```
docker volume create my-named-volume

docker run --volume=my-named-volume:/go/src/drone_test mongo:4.0.2
docker run --volume=my-named-volume:/go/src/drone_test golang
docker run --volume=my-named-volume:/go/src/drone_test plugins/slack
docker run --volume=my-named-volume:/go/src/drone_test robertstettner/drone-codecov
```

這樣你在跑 test 或 build code 或 build docker image 並 push 上去時都會在同一個目錄中(且 code 不需要重新拉，因為每個 pipeline step 都會在一個 docker image 操作)

## Clone

```yaml
clone:
  git:
    image: plugins/git
    tags: true
```

這段即使不寫，drone 也預設會幫你補上，原因在於 drone 需要使用 plugins/git image 上的 git 指令將你的 code 拉下來，不過這邊多些的原因在於

```diff
clone:
  git:
    image: plugins/git
+   tags: true
```

預設 drone 是不會接收 tage 這個 event 的，所以假設你希望再有打版號的情況下才觸發該 pipeline step，這邊就需要補上 `tags: true`，或者是在 web ui 的該專案的 `Settings` 內打開它

![drone web ui settings](/public/img/post/drone/7.png)

## Service

```yaml
services:
  database:
    image: mongo:4.0.2
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=admin
      - MONGO_INITDB_DATABASE=MYDB
```

程式測試所遇到的其他服務(MySQL, redis…)，這邊假設你的程式需要連接 DB，這邊這樣寫就會起一台測試用的 DB

有沒有發現這個 environment 跟 docker-compose 完全一模一樣 XD

但這樣帳號密碼就跟著一起進 git 了！！！   要怎樣避免呢？  等下一篇吧

不過聰明的你應該已經發現上面的範例中有註解起來的東東了

## Pipeline Step

接下來屆是本體啦

```yaml
test:
  image: golang
  environment:
    - TEST_TEST=test_environment
  commands:
    - echo $TEST_TEST
    - go test 
    - go test -v -cover -coverprofile coverage.out
```

其實也沒什麼好講的，基本上 drone 會把你的 commands 寫成 script 後執行，就醬

然後跟 docker-compose 一樣可以加上 environment 跟 volumes

```bash
#!/bin/sh
set -e

echo $TEST_TEST
go test 
go test -v -cover -coverprofile coverage.out
```

### Plugin

> http://plugins.drone.io/

接下來你看到的 

```yaml
slack:
  image: plugins/slack
  channel: drone_test
  # secrets: [ slack_webhook ]
  webhook: https://hooks.slack.com/services/....
  when:
    status: [ success, failure ]

codecov:
  image: robertstettner/drone-codecov
  token: ....
  files:
    - coverage.out
  when:
    event: [ push, pull_request ]
```

就是 drone 的 plugin 了，做的事情分別為

- 當 pipeline 執行 success 或 failure 時就通知 slack 中的 drone_test channel
- 將測試涵蓋率的檔案丟到 codecov 的服務中，然後就會在該 pr 中的 Comments 產生漂亮的測試涵蓋率比例圖(下圖)

![codecov Bitbucket Comments](/public/img/post/drone/8.png)

還沒研究 plugin 怎麼寫，不過看起來就只是將你要的功能包成 docker image 而已   \_(:3 」∠ )\_

## 結語

所以目前看來，如果你本來就或 docker 跟寫簡單的 script 經驗，基本上 drone 的學習曲線蠻低的

下一章會講到進階一點的 pipeline，不過最近又跳了一個坑，啥時會寫出來就不知道了 (つд⊂)

不過還好沒腦衝報名 it 邦的鐵人賽，這系列文章大概再來個幾便就全部講完了，如果報名了因該幾天後就沒東西講了

## 系列文章

- [Drone - Re: 從零開始的 CI 生活]({{ site.url }}/2018/09/28/drone-101/)