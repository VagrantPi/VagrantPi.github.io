---
layout: post
title: "iT 邦幫忙鐵人賽爬蟲 x Pocket API"
tagline: "使用 Python 3.x爬蟲 iT 邦幫忙鐵人賽系列文章，並將其加進 Pocket 的小專案"
description: "使用 Python 3.x爬蟲 iT 邦幫忙鐵人賽系列文章，並將其加進 Pocket 的小專案，幫助您更方便地閱讀 iT 邦幫忙鐵人賽文章"
author: VagrantPi
tags: Crawler Pocket
imgurl-fb: /public/img/index/pocket.png
imgurl: /public/img/index/pocket.png
image: /public/img/index/pocket.png
imgalt: pocket 
---

## 前言

整天盯著電腦，晚上又用手機漫畫滑 PTT ，最近眼睛實在是太酸了

突然想起了之前很想買的電子閱讀器

研究了幾家常見的牌子，最後挑了樂天的 libra H2O，原因有：

- 主流都是 6 吋，方便攜帶，但太小了，去三創試用一下感覺 7 吋剛剛好，8吋以上覺得攜帶
- 有內建整合 Pocket ，所以可以直接閱讀一些有文字有圖片的網頁（內建的網頁瀏覽器螢幕刷新率都不忍直視
- 防水（有就加分，可以拿去廁所看了 X (ﾟ∀。)
- 同尺寸價位相對算便宜

![](/public/img/post/ithone-pocket/img4.jpg)

![](/public/img/post/ithone-pocket/img3.jpg)

![](/public/img/post/ithone-pocket/img2.jpg)

## Pocket

Pocket 是一個類似瀏覽器書籤的工具，應該也很多人跟我一樣，累積了一堆待看網頁，然後越積越多，~~然後就成為了分頁魔人~~

使用 Pocket 將網頁使用閱讀模式在多種平台上顯示， 如上下班通勤時，可以用手機打開閱讀，並且也有有聲書模式（Google 小姐念給你聽

除此之外也能幫這些添加的網頁加上 Tag，未來在尋找文章時很方便，使用 Tag 過濾一下即可，也支援封存，或我的最愛等功能，是個很棒的書籤管理器

詳細功能可以參考我當初入坑的文章

> [Pocket Read it later 稍後閱讀同步、離線、免費行動口袋](https://www.playpcesor.com/2012/04/pocket-read-it-later.html)

## iT 邦幫忙鐵人賽爬蟲

前面有提到這個電子書閱讀器有內建有整合 Pocket

且我很喜歡讀 iT 邦幫忙鐵人賽 系列文章，不管是複習已知資訊，或這是快速的了解一個領域。

但是需要一個一個頁面添加太麻煩了（有完賽的文章通常有 30 頁 up），所以自動化是肯定的 (ﾟ∀ﾟ)

專案傳送門:

https://github.com/VagrantPi/Ithelp-Ironman-Crawler-Pocket

短短幾行扣而已，反而弄 Pocket API token 時間跟測試可能還比較久

## Pocket API

Pocket API 在使用前需要先新增一個 App 然後選擇授權

原本只要選 Add 就好但因為 Batch Add 好像被歸類在 Modify，所以乾脆全勾了 

### Step 1. Obtain a platform consumer key

https://getpocket.com/developer/apps/new

![](/public/img/post/ithone-pocket/create.png)

建立完後你會拿到一個 consumer key，大概長這樣: 1234-abcd1234abcd1234abcd1234

### Step2. Obtain request token

這邊 是採用 Oauth 2 的方式拿到 access token 的，所以要先拿到 request token ，然後再去要用戶授權

這邊的 redirect_uri 是之後取得用戶授權後轉跳的網址，印象中 Oauth 2 會把 access token 送到這個 endpoint 才對，但這邊是 API 直接回傳給你，但我完全沒接到，官方教學也沒有寫很細，而且我發現隨便填好像也沒差 0.0

Request:

```javascript
curl --location --request POST 'https://getpocket.com/v3/oauth/request' \
--header 'Content-Type: application/json' \
--data-raw '{
    "redirect_uri": "https://vagrantpi.github.io/",
    "consumer_key": "1234-abcd1234abcd1234abcd1234"
}'
```

Response:

```
{"code":"dcba4321-dcba-4321-dcba-4321dc"}
```

### Step 3: Redirect user to Pocket to continue authorization

拿剛剛回傳的 code 組成用戶授權的網址

```
https://getpocket.com/auth/authorize?request_token={{code}}&redirect_uri={{redirect_uri}}
```

直接用瀏覽器打開

![](/public/img/post/ithone-pocket/oauth.png)

### Step 4. get Pocket access token

授權完後會轉跳，不用理它，接著來拿 **access token**

Request:

```javascript
curl --location --request POST 'https://getpocket.com/v3/oauth/authorize' \
--header 'Content-Type: application/json' \
--data-raw '{
    "consumer_key": "1234-abcd1234abcd1234abcd1234",
    "code": "dcba4321-dcba-4321-dcba-4321dc"
}'
```

Response:

```
{"access_token":"5678defg-5678-defg-5678-defg56",
"username":"pocketuser"}
```

## 使用 Pocket API

> https://getpocket.com/developer/docs/v3/modify

如果要批次做事的話要呼叫 Modify API

```javascript
curl --location --request POST 'https://getpocket.com/v3/send' \
--header 'Content-Type: application/json' \
--data-raw '{
    "consumer_key": "1234-abcd1234abcd1234abcd1234",
    "access_token": "5678defg-5678-defg-5678-defg56",
    "actions": [
        {
            "action" : "add",
            "url": "https://ithelp.ithome.com.tw/articles/10199458",
            "tags": "test"
        },
        {
            "action" : "add",
            "url": "https://ithelp.ithome.com.tw/articles/10200384",
            "tags": "test"
        }
    ]
}'
```

帶上 consumer_key、access_token 就可以使用了


![](/public/img/post/ithone-pocket/pocket.png)


## 結語

整個腳本使用起來如下

![](/public/img/post/ithone-pocket/screen.png)

![](/public/img/post/ithone-pocket/kobo.jpg)


最近待業中，為了找工作要刷題，不過一整個沒有幹勁

但寫這小專案時整個活力都來了，果然偷懶是工程師的天命呢

我好棒 ヽ(●´∀`●)ﾉ

![](/public/img/post/ithone-pocket/meme.png)

