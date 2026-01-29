---
layout: post
title: "開發者之夜- Sui 項目方Scallop創辦人Kris親臨現場分享+ Web3開發者的未來與機會"
tagline: "這年頭做 Web3 創業家的心路歷程"
description: "參加了 Sui 開發者之夜，聽 Scallop 創辦人 Kris 分享從 Solana 到 Sui 的轉折，以及如何面對 VC、黑客松與市場寒冬的寶貴經驗。"
author: VagrantPi
tags: Sui EventNote 創業相關 Blockchain
imgurl-fb: /public/img/index/scallop.jpg
imgurl: /public/img/index/scallop.jpg
image: /public/img/index/scallop.jpg
imgalt: "Sui Developer Night Event Banner"
---

![eventbanner](/public/img/post/sui-scallop/sui-dev-night-scallop.jpg)

> event: https://luma.com/oaz0ggyu?tk=UyX5iI

<br>

## 前言

25 年可以說是幣圈重要里程的一年，隨著川普投顧的大力推導下，以及美國各大機構陸續通過虛擬貨幣 ETF，加密貨幣產業終於開始冒出頭。

而如果按照過往減半牛市，25 年 10-11 月應該是處於牛熊交界處了，每次都會說這次不一樣了，這次真的不一樣了嗎？還是真正進入了 **Supercycle** 了，我們就交由時間來驗證了。

近期 Move 生態系活動連連，前陣子剛參加完 IOTA workshop，之後又接著參加了 Sui 的活動，身為水家人肯定不能錯過的

這次參加了「開發者之夜」，主講者是 Sui 鏈上的借貸協議 **Scallop** 的創辦人 Kris。

聽了一場含金量極高的「創業生存指南」。從 Solana 到 Sui，從沒人理到被 VC 追著跑。

這篇文主要整理了 Kris 的分享重點，以及小弟我的一些粗淺反思。

<br>

---

## Scallop 是什麼？

![scallop](/public/img/index/scallop.jpg)

先快速帶過 Scallop 在做什麼的。它是 Sui 鏈上的一個 DeFi 協議，主要功能包含：

* **Lending (借貸)**
* **Swap & Bridge**
* **Flash Loans (閃電貸)**
* **PTB Tool (Programmable Transaction Blocks)**
    * Sui 特有的可編程交易區塊工具。

但在技術規格之外，Kris 分享的「心路歷程」才是這次的重點。

<br>

---

## Web3 開發者的第一道坎：語言與行銷

![](/public/img/post/sui-scallop/1.jpg)

對於台灣開發者來說，技術通常不是最大的問題，最大的問題往往是 **「英文」** 和 **「行銷」**。

Kris 提到，英文是個硬傷，但在 Web3 的世界裡，不跨過這個坎就無法接觸到國際的資源。而行銷更是工程師的死穴，我們習慣埋頭苦幹，但做產品如果不喊出來，根本沒人知道你在幹嘛。

<br>

---

## 黑客松起家：從 Solana 到 Sui 的流浪記

![](/public/img/post/sui-scallop/2.jpg)

Scallop 並不是一開始就長在 Sui 上的。

### 1. 夢開始的地方：Solana

一開始他們是在 Solana 上起家，參考了 **PoolTogether**（無損彩票）的模式。當時的想法很單純，想接觸 VC，但這過程充滿了挫折。

Kris 分享了一個觀點：
> 只要是在風口上，VC 其實很積極接觸。
> 
> **反思**：如果 VC 不理你，除了產品問題，或許該反思你做的事情是否符合當下的「產業趨勢」。

即便當時沒有拿到大錢，但他們透過瘋狂參加黑客松（Hackathon），認識了很多 VC 和顧問。這些人脈在當下看似沒用，但當用戶量起來後，這些人就會回頭了。

### 2. 轉折點：FTX 爆炸與換鏈

就在他們在 Solana 生態系打滾時，遇到了 FTX 倒閉。而剛好在倒閉前也與 FTX 的員工交流過，發現連內部人都覺得生態系不穩，目光轉向了 Aptos 和 Sui。

這時候面臨了一個巨大的抉擇：**換鏈 (Pivot)**。

這不是開玩笑的，換鏈意味著：
* **人脈重零開始**：原本 Solana 的朋友幫不上忙了。
* **技術債**：Sui 用的是 Move 語言，所有技術問題都要重新解決。
* **投資人解釋**：要怎麼跟既有的天使投資人交代？

### 3. 如何說服 VC？

Kris 提到，VC 在天使輪看重的其實是 **「團隊」**（潛在的可能性）。只要團隊展現出足夠的成長與積極度，轉鏈並非死路。

這裡他推薦了一個神級資源：
* [Sequoia Capital Pitch Deck Template (紅杉資本簡報範本)](https://www.slideshare.net/slideshow/sequoia-capital-pitchdecktemplate/46231251)

> **筆記**：
> 參加 Layer 1 的 Builder House 即使錢不多，但重點是那個 **Title**。得獎的信用疊加起來，才是跟大 VC 談判的籌碼。

<br>

---

## 產品轉型：實力的證明

![](/public/img/post/sui-scallop/3.jpg)

除了換鏈，Scallop 的產品方向也從 PoolTogether 轉向了更底層的「借貸協議」。這中間有個有趣的插曲：**CTF (Capture The Flag)**。

創辦人本身是資安背景，到處打 CTF 比賽。對於講究安全性的借貸協議來說，還有什麼比「創辦人是資安大神」更好的背書呢？

### 堅持與認知升級

在市場最冷的時候，他們持續參加比賽。Kris 提到，隨著比賽越打越多，對產品的「認知」會逐漸與市場需求對齊。

> **過程是這樣的**：
> 一直得到 Feedback -> 不斷修正 -> 不斷得獎 -> 但依然沒有融資到多少錢 `Σ(ﾟДﾟ；≡；ﾟдﾟ)`

雖然錢沒進來，但實力與信用一直在累積。

### 爆發期：當聚光燈打在身上

最後，當 VC 的熱點終於轉到了 Sui 鏈上時，一直在这个垂直赛道耕耘的 Scallop 自然就被看見了。

這時候的心態轉變很有趣：
> 當聚光燈轉到自己頭上，策略要變了。
> 不能再是「錢來就收」，而是要 **審慎篩選 VC**。要想的是如何讓項目長遠發展，創造雙贏。

<br>

---

## 總結：給開發者的建議

![](/public/img/post/sui-scallop/4.jpg)

整場聽下來，我覺得核心關鍵字就是 **「累積信用」**。

1.  **保持熱情**：當商業模型暫時不可行時，支撐你走下去的是熱情。
2.  **跨領域連結**：不要只當個 Coder，去連結人脈、去行銷、去碰撞。
3.  **刷經歷**：不斷打黑客松不是為了獎金，是為了籌備資金與曝光。

### Q&A 精華

最後的 Q&A 有幾個點我覺得很棒，直接條列出來：

* **如果項目創新度贏不了別人怎麼辦？**
    * 改變思維，去處理「生態系基礎建設」。這樣你的項目會跟隨著鏈的市值一起成長。（典型的賣鏟子哲學）
* **如果黑客松題目跟自己團隊題目不同？**
    * 主動聯繫項目方！也許那是他們沒想到的盲點，你就成了該賽道的領導者。
* **融資不到錢怎麼辦？**
    * 講師回了一句：「如果連一張 10k 的票都融不到，那要回到根本性問題。」
        * 是行銷爛？體質爛？還是方向錯了？缺哪邊就補哪邊，不要怪市場。

<br>

---

<br>

## 結語

血淋淋又勵志的心路歷程分享，過往新創打滾的經歷其實也驗證了新創公司成功活下來的真的不多。

Scallop 協議能有今天，不是隨隨便便發發白皮書或是貼一串地址說要發幣，而是實實在在的蹲了很久。

只能說沒有滿腔熱情真的撐幾年就不行了，非常勵志

