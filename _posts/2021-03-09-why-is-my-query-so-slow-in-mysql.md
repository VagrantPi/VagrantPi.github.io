---
layout: post
title: "Why is my query so slow in MySQL? 活動筆記"
tagline: "MySQL 查詢慢的原因是什麼？優化 MySQL 查詢效率的技巧"
description: "MySQL 查詢慢的原因是什麼？這篇文章將幫助您了解 MySQL 查詢慢的原因，並提供一些優化 MySQL 查詢效率的技巧"
author: VagrantPi
tags: EventNote DB
imgurl-fb: /public/img/index/mysql.png
imgurl: /public/img/index/mysql.png
image: /public/img/index/mysql.png
imgalt: mysql 
---

## 前言

![eventbanner](/public/img/post/why-is-my-query-so-slow-in-mysql/2102230719107391064490.png)

久違的參加活動，寫個筆記

> [為何我在MySQL的查詢老是慢吞吞? Why is my query so slow in MySQL?](https://www.accupass.com/event/2102230717537215955700)

## agenda

- key
- index
- query execution plan
- Q&A

> Q: DB 慢，改設定參數？
> A: 有些設定可以加速的，但可能造成當機時會有資料損失

效能影響：

query > DB schema > hardware configuration > Mysql configuration > heigh currency

## key

### schema

不必要的資料長度 ex: `name varchar(255)`

![](/public/img/post/why-is-my-query-so-slow-in-mysql/td08dyw.png)

table 規劃越小越好（依要實作的功能最好作好正規化

## index

index occupy space on disk in memory buffers

index maintain 也是需要 i/o 的，所以頻繁更動欄位加 index 也會造成效能問題

## query execution plan

不必要的 index 過多會導致 query optimizer 混淆，而選擇了錯誤的 index 做查詢

> 且 index 過多會造成 optimizer 判斷時間變長（需實驗一下

複合鍵的情況下，如果 query 條件在 open range(大於小於之類的)之後的判斷式就不會使用到 index

EX: 

```
index(a, b, c)

where a='x' and b>5 and c = 'x'

此時會撈出 `index(a, b, c)` 中的 a='x' and b>5，然後再過濾掉 c = 'x'
```


### 驗證 index 在查詢時是否用到

-> mysql explain

cardinality 值越高代表獨特性越高，時會早較高的

> http://blog.twbryce.com/mysql-explain/
> 
> ![](/public/img/post/why-is-my-query-so-slow-in-mysql/MLcCY64.png)
> * type：顯示使用了何種類型。從最優至最差的類型為const、eq_reg、ref、range、indexhe、ALL。
> * possible_keys：顯示可能使用到的索引。此為從WHERE語法中選擇一個適合的欄位名稱。
> * key：實際使用到的索引。如果為NULL，則是沒有使用索引。
> * key_len：使用索引的長度。長度越短 準確性越高。
> * ref：顯示那一列的索引被使用。一般是一個常數(const)。
> * rows：MySQL用來返回資料的筆數。
> * Extra：MySQL用來解析額外的查詢訊息。如果此欄位的值為：Using temporary和Using filesort，表示MySQL無法使用索引。


## Q&A

review 所有用到該張表的 SQL 分析 cardinality 低下的 index（然後其實可以刪除以增加效能

like 的 % 放在前面或後面（'xxx%', '%xxx'）會有差別

- 'xxx%' 因為可以知道前面的值，所以搜尋欄位可能可以吃到 index
- '%xxx' 這類為可能做 full scan，因為前面是模糊搜尋

---

index 越長，成本越高，所以複合式 index 可以的話，可以考慮縮減 index

---

merge index

OR 條件時

index(a), index(b) 

where a = 'x' or b = 'x'

此時會`可能`造成 merge index 然後效能會變差（通常效能是比較好的

所以竟量不要設計成會造成 merge index 的 index，不過實際情況還是要依照功能 explain 來分析，optimizer會不會吃到 merge index。

又如果這對搜尋非常頻繁，可以設成複合 index

---

基本上DB 效能優化都是 case by case


