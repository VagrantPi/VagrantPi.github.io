---
layout: post
title: "Docker 預設 Log 無限增長問題"
subtitle: "Docker configure logging drivers"
description: "系統硬碟異常增加，今過排查後發現的一些問題紀錄"
author: VagrantPi
tags: Docker Prometheus Grafana
imgurl-fb: /public/img/index/docker.jpg
imgurl: /public/img/index/docker.jpg
image: /public/img/index/docker.jpg
imgalt: docker-icon
---

## Intro

客戶公司主機有個奇怪的現象，每週六定期會當機，每次重啟機器後就好了，查了一下 log 發現

```
Put app data to redis error: MISCONF Redis is configured to save RDB snapshots, but it is currently not able to persist on disk. Commands that may modify the data set are disabled, because this instance is configured to report errors during writes if RDB snapshotting fails (stop-writes-on-bgsave-error option). Please check the Redis logs for details about the RDB error.
```

難道是 Redis 寫爆了硬碟嗎！？但是這邊程式相對單純，只是把一些常用資料定期從 DB 抓到 Redis 而已，而且當下的硬碟使用量還有 30% 左右的空間，Source Code 看來看去也沒看到奇怪的地方，程式的 log file 也 `195M` 左右。

這時想到了之前幫公司導入的 Prometheus，於是將客戶硬體資訊接到 Prometheus 上，放了幾天後觀察。

![](/public/img/post/docker-log-size/1.jpg)

硬碟增長的速度很明顯的不正常

## 排查的過程

容量異常增長，那代表有的地方不斷地寫資料，因此簡單的 `sudo du -sh /` 來查看根目錄資料夾資訊

然後一層一層往內找，最後發現了在 `/var/lib/docker/containers` 內，container 的 log file 異常的大。

突然想到客戶的程式也有爬蟲，且資料都是直接往 stdout 印

但是，docker logs 的 default 設定應該也會限制吧？

查了一下官網文件

[Configure logging drivers](https://docs.docker.com/config/containers/logging/configure/)

一打開文件馬上看到一個警告

![](/public/img/post/docker-log-size/0.jpg)

可以使用下面指令取得目前的 log 儲存方式

```
$ docker info --format '{{.LoggingDriver}}'
json-file
```

而 Docker 支援很多種 log 儲存方法

[Supported logging drivers](https://docs.docker.com/config/containers/logging/configure/#supported-logging-drivers)

Driver | Description
-------|-------------
none | No logs are available for the container and docker logs does not return any output.
local | Logs are stored in a custom format designed for minimal overhead.
json-file | The logs are formatted as JSON. The `default` logging driver for Docker.
... | 文件中還有很多，這邊不依依列出


讓我們來看看 json-file 的設定

[JSON File logging driver](https://docs.docker.com/config/containers/logging/json-file/#options)

Option | Description | Example value
max-size | The maximum size of the log before it is rolled. A positive integer plus a modifier representing the unit of measure (k, m, or g). `Defaults` to -1 (`unlimited`). | --log-opt max-size=10m
max-file | The maximum number of log files that can be present. If rolling the logs creates excess files, the oldest file is removed. Only effective when max-size is also set. A positive integer. Defaults to 1. | --log-opt max-file=3

好的，所以很明顯看到問題點了

## 測試一下

我們簡單寫個印 log 的 script，`log.sh`

```bash
while :
do
    for i in {1..1000000}
    do
        echo "test $i"
    done
    sleep 3
done
```

包成 Dockerfile

```yaml
FROM bash
WORKDIR /scripts
COPY log.sh .
CMD ["./log.sh"]
```

寫個 Makefile 來處理 build 跟 run，`Makefile`

```shell
REPO_NAME=kais/log-test

all: build

build:
	docker build --force-rm -t $(REPO_NAME) .

run:
	docker run --rm --name log_test -d $(REPO_NAME)

runLogMaxSize:
	docker run --rm --log-opt max-size=50m -d $(REPO_NAME)
```

在寫個腳本印出 docker log file 的變化，`logSize.sh`

```bash
CONTAINER_ID=2c2bdac32c4af874a3a7140d45d55782a23d44c9f2d2893a3efef0dc0b9f57d0 
while :
do
    sudo du -h /var/lib/docker/containers/$CONTAINER_ID/$CONTAINER_ID-json.log
    sleep 2
done
```

跑起來看看

![](/public/img/post/docker-log-size/2.jpg)

可以發現如果你有個程式會瘋狂印 log，那檔案會 `unlimited` 增長

這個 Container 要在 rm 或者是 docker-compose down 移除後，才會移除

再加上 `max-size=50m` 後，再印印看

![](/public/img/post/docker-log-size/3.jpg)

OK，搞定

另外如果使用 docker compose 的話可以在 services 那一層加上

```yaml
    logging:
      options:
        max-size: "500m"
        max-file: "3"
```

## 結語

很多服務 default 值並不是最佳設定

但其實文件都有寫到，不過沒遇到問題應該也不會去看文件 XD


