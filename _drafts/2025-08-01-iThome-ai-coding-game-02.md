---
layout: post
title: "Day02 - 零經驗也能啟動專案？交給 AI 全權處理！"
tagline: ""
description: "在沒有任何遊戲背景下，我讓 ChatGPT 當我的專案經理，一句指令開啟開發之路。"
author: VagrantPi
tags: iThome AI
imgurl-fb: /public/img/
imgurl: /public/img/
image: /public/img/
imgalt: "2025 iThome鐵人賽"
---


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


















