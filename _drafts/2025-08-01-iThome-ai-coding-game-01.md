---
layout: post
title: "Day01 | 從發想出發：為什麼是迷因？為什麼是河馬？"
tagline: "用 ChatGPT 企劃一款放置型療癒遊戲"
description: "一個放置遊戲的靈感從哪來？聊聊我為什麼選擇『迷因河馬』做為主角，以及這背後的技術與創意初衷。"
author: VagrantPi
tags: iThome AI SideProject
imgurl-fb: /public/img/
imgurl: /public/img/
image: /public/img/
imgalt: "2025 iThome鐵人賽"
---

![day01 banner](/public/img/post/2025-iThome/day01/day01_banner.png)

## 前言

現在是大 AI 時代，當你爸媽也開始使用吉普力畫風當 Line/Meta 的大頭照時，可以深刻感受到這已經不只是屬於 RD 們的玩具了

並且 AI 進入了一個大內卷時代，各式大語言模型與工具接連發布

這週可能還在 Gemini 剛 release 新的產圖算法，看到推特各種神人產出各種厲害的東西，一兩週後就換吉普力畫風的 ChatGPT 風靡全球

而緊接而來的各種低代碼 AI 工具也相繼出現（e.g. n8n, Make）各式教學文章、傳道士、學習社團雨後春筍般的出現

很不意外的接下來就是各種『0 經驗也能寫程式』課程強力打廣告，正式進入人人都要學 AI 的時代

而現實生活中確實有些人沒有程式背景的人已經通過 AI 賺入大把大把的鈔票

陳幾何時『Talk is cheap. Show me the code』現在應該變成了 『[Code is cheap. Show me the talk](https://x.com/Jason_Young1231/status/1935180703416897895)』

Vibe Coding、MCP、Agent 相關工具或新名詞接踵而至，好像在不學一下 AI 就要被這時代給拋下，對於 RD 來說可能是最壞的時代，也是最好的時代

前同事也在待業期間用 AI 做了一款 app [時時抄經](https://www.threads.com/@solomeowl/post/DMtoMXYzF82?xmt=AQF0awqOUSXJyneKwBYX3TUJLur9X13nlZqgMsFcZf_Vtg)，太神啦！！我也要來玩玩！！！

至於為何要選擇遊戲當題材呢？憶想當年是為了想寫遊戲才念資工系的，不過大學時（2017年）發現台灣遊戲產業要不是博弈，剩下的遊戲公司幾乎都是用愛發電，在理想與麵包中我選擇了麵包

所以這次選了手遊題目當切入點，一來是為了圓一個小小的遊戲夢，二來是想試試看做完全領域外的產品可以做到什麼程度

## 我是誰？本系列的使用手冊

我是 Kais，是位在區塊鏈新創打滾 7 年的後端工程師

從來沒碰過任何遊戲相關程式語言或參與任何遊戲設計相關流程（完全沒有相關 Know How）

然後手邊只有付費的 ChatGPT 跟免費版本的 Windsurf，就 AI 協作經歷上並不算長

所以如果你想要看的是高超的 AI 使用技術、完全小白超神 Vibe Coding 或是深入探討某個 AI 工具怎麼使用，那麼你也許會失望

這邊從一個略懂程式碼的 RD 使用 AI IDE 協作的方式從頭開始到完成一個完整專案的過程紀錄

內含了些個人在開發上與 AI 協作的使用技巧與踩雷紀錄

## 先來設定一下題目

現在只有個簡單的概念，我想要做一個放置類手遊

原因是因為蠻喜歡這類非常『輕』的遊戲類型，在這個資訊碎片化日益嚴重的時代，太肝或太花時間的已漸漸地淡出我的生活

至於故事或玩法什麼的完全沒有想法

那我們就先來請一位專業的遊戲企劃，請他調研最流行的動物是什麼？且希望可以國際化一點而非特定區域特別流行

![請 ai 調研遊戲角色 1](/public/img/post/2025-iThome/day01/1_1.png)

可能是我特別提到抖音與小紅書，還有人口基數要加入進去考慮，因此他給的的排名來源前 5 名中，其中小紅書、抖音、中國流行的動物就佔了 4 位

![請 ai 調研遊戲角色 2](/public/img/post/2025-iThome/day01/1_2.png)

這邊我選擇了河馬，原因是因為我很喜歡河馬迷因 [Moo Deng(彈跳豬)](https://zh.wikipedia.org/zh-tw/%E5%BC%B9%E8%B7%B3%E7%8C%AA)

![](https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Moo_deng_%E0%B8%AB%E0%B8%A1%E0%B8%B9%E0%B9%80%E0%B8%94%E0%B9%89%E0%B8%87_%282024-09-11%29_-_img_02.jpg/500px-Moo_deng_%E0%B8%AB%E0%B8%A1%E0%B8%B9%E0%B9%80%E0%B8%94%E0%B9%89%E0%B8%87_%282024-09-11%29_-_img_02.jpg)

## 請 AI 專業遊戲企劃設計玩法

對話如下

Q:

```
好的身為一個資深遊戲企劃，我希望你把河馬當主角，設計一款爆款的放置型遊戲

提供我現在想到的一些想法給你參考，不過使不使用依照你的專業評估

目前想到的商業模式為：
- 部分的裝備升等需要看廣告
- 依照現在等級，可以每日查看廣告可以得到的金幣會不同，以此賺取廣告收入
- 分區的天梯排名讓用戶有往上爬的動力
- 要給後段班的用戶也有一些獎勵，激勵他們不要放棄
- 以看廣告為主要營收，但你評估看看購買去除廣告的選項是否符合經濟效益
```

A:

```
太好了，我會幫你設計一款以「河馬」為主角的爆款放置型手遊。在我進行具體設計前，想請你補充幾點以確認方向：

1. 你希望這款遊戲偏向哪種類型的美術風格？（例如卡通Q版、簡筆畫療癒風、奇幻3D、極簡風格等等）
2. 是否有目標主要市場？例如是先針對中國市場、全球同步、還是東亞為主？
3. 你預期的遊戲主線是偏純放置經營，還是可以加一點冒險或迷你互動元素？
4. 遊戲是否會有社交功能（如好友排行、贈禮、留言板等）？

提供這些資訊後，我就能根據你提供的商業模式與核心方向，打造出一套完整的爆款遊戲設計企劃書。
```

Q:

```
1. 極簡＋Ｑ版
2. 先以亞洲市場為主要營運，但一開始回事全球同步下載
3. 輕鬆一點，但希望他們會打開來點廣告
4. 盡可能簡單，初期希望一台 2cpu 4Gram vm 能扛著全球流量就好，我期望他會是一的低依賴後端的遊戲設計
```

A:

[Q 版河馬主角的極簡風放置型手遊設計方案](https://drive.google.com/file/d/19PHEfZVf2mN3t-BLN1FVwzlACXNN999-/view?usp=drive_link)


兩次的對談就幫我產生完整玩法與簡單的商業模式，真的高效率

## 遊戲企劃有了，下一步呢？

接下來，因為你完全沒有經歷過遊戲開發，我大概能猜到下一步就是決定美術風格跟美術素材

不過我們還是來詢問一下專業的 AI 遊戲企劃

Q:

```
好的，我現在是一位個人工作室，你則是我聘請的資深遊戲企劃，我沒有做過任何遊戲的經驗，請告訴我接下來第一步要做什麼？


我希望的合作方式為
1. 給我整個專案的 roadmap
2. 指導我該如何進行，身為經驗豐富的遊戲企劃你可以指揮我來完成這個專案
```

A:

```
🟢 第 0 階段｜立項與可行性驗證（Week 1）
...

🟡 第 1 階段｜MVP 設計規劃（Week 2~3）
目的：定義你第一個版本需要做出什麼內容。
🔜 撰寫遊戲設計文件（GDD，Game Design Document）
包含數值設計、裝備成長邏輯、UI 草圖、廣告設計邏輯
🔜 畫出畫面草稿（可手繪也可以用 figma）
🔜 設計基本 UI 流程圖（從進入遊戲到獲得金幣為止）
🔜 確定開發技術棧（Unity、Godot 或 Flutter + Flame…等）

🟠 第 2 階段｜Prototype 快速打樣（Week 4~6）
...
🔵 第 3 階段｜Alpha 版本製作（Week 7~10）
...
🔴 第 4 階段｜封測與優化（Week 11~13）
...
🟣 第 5 階段｜上架與行銷準備（Week 14~15）
...
🟢 第 6 階段｜上架與營運（Week 16+）
...
```

好的，與預想的流程差不多，第 0 階段也完成了，接下來來處理美術吧

Q:

```
好的，我們先從角色還有整體美術風格下手好了
我不會任何美術或繪畫能你，應該使用其他 AI 工具來完成

請給我遊戲中需要的所有可能會出現的物件，並且給我一至性的 Prompt 好讓我產生對應一至性的圖片

舉例：
- 按鈕元件：鉛筆手寫質感，淺色的案件....
- 裝備 1 泡澡按摩器：鉛筆手寫質感，....

這只是舉例，你按造你的專業經驗來給我美術建議
```

A:

```
🎨 美術風格總體方向（統一描述）
我們採用以下統一設定來生成所有素材，確保風格一致：

風格描述（統一加在每個 prompt 開頭）：
"cute minimalistic hand-drawn style, soft pastel color palette, pencil sketch texture, round edges, Japanese kawaii, child-friendly, white background, mobile game UI style"

這個風格類似《Cats & Soup》《Neko Atsume》《Kleptocats》等遊戲的手繪感、可愛風，非常適合用 AI 圖像工具（如 Midjourney、DALL·E、Leonardo）來產出。

🧱 美術元件清單 + Prompt 建議
以下我幫你列出常見的遊戲內物件，並對應建議的 AI prompt：

🦛 角色
主角河馬寶寶（泡在水裡）

a cute baby hippo relaxing in a small round pool, floating with a melon slice, round body, simple black dot eyes, blushing cheeks, in a cute minimalistic hand-drawn style, soft pastel colors, pencil sketch texture, mobile game

...
```

讚讚，看起來一切順順利利，制定完題目跟取得接下來的 roadmap 了，美術也有通用的 prompt 加在開頭

接下來就是順順的產圖片素材，就可以進入到程式開發流程了

## 本日成果

- [Q 版河馬主角的極簡風放置型手遊設計方案](https://drive.google.com/file/d/19PHEfZVf2mN3t-BLN1FVwzlACXNN999-/view?usp=drive_link)
- 制定執行階段
- 確立美術風格

## 小結

在不知道遊戲製作流程下，連題目都非常的不明確，AI 還能夠給我很明確的建議與目標

不喜歡他提供的方案可以針對性的小局部的做調整，就目前使用起來還算體驗不錯







