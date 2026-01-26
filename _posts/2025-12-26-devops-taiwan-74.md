---
layout: post
title: "DevOps Taiwan Meetup #74 筆記 - Grafana AI 應用與多租戶 SaaS 架構導讀"
tagline: "從 AI 查修到 SaaS 架構演進，週末充值信仰的 DevOps 筆記。"
description: "紀錄 DevOps Taiwan Meetup #74 內容，包含《Grafana Zero to Hero》與《建構多租戶 SaaS 架構》兩本新書導讀，探討 Grafana 結合 Claude MCP 的查修應用，以及 SaaS 多租戶架構的四大難題與解決方案。"
author: VagrantPi
tags: DevOps Grafana SaaS Architecture Meetup EventNote AI
imgurl-fb: /public/img/index/grafana.jpeg
imgurl: /public/img/index/grafana.jpeg
image: /public/img/index/grafana.jpeg
imgalt: "DevOps Taiwan Meetup 筆記圖示"
---

![eventbanner](/public/img/post/devops-taiwan/74/devops-meetup-74.jpg)

> event: https://devops.kktix.cc/events/meetup-73


## 前言

這次 Meetup 為兩本書的導讀，所以很多都為點到為止

剛好之前有用顧 Grafana，而多租戶 SaaS 之前在小新創公司碰過，但整個系統框架還沒摸熟公司就倒了

所以此次題目都蠻感興趣的

---

## Grafana：建立系統全知視角的捷徑

![](/public/img/post/devops-taiwan/74/1.jpg)

> **Slide:** [Grafana：建立系統全知視角的捷徑](https://speakerdeck.com/blueswen/grafana-jian-li-xi-tong-quan-zhi-shi-jiao-de-jie-jing)

第一場是關於大家都熟到不能再熟的 Grafana。但這次講者帶來的內容不僅僅是拉拉 Dashboard，更多的是現代化監控以及 AI 賦能的應用。

### Drilldown App：免下語法直接抓 Bug

身為工程師，每次機器炸掉要查 Log / Metrics，或是要新增 Grafana 圖表時都要下各種 PromQL 或是 LogQL 語法。

Grafana 的 Drilldown App 解決了這個痛點，讓你可以**不需要下各種查詢語法**就能簡單地找到問題點。

> **注意：** 目前有限定支援的資料源，主要是 Grafana 自家的一條龍：Metrics (Prometheus) / Logs (Loki) / Traces (Tempo) / Profiles (Pyroscope)。

### 當 Grafana 遇上 Claude MCP

這大概是整場最讓我眼睛一亮的部分。透過 MCP (Model Context Protocol)，讓 Claude 分析問題

![](https://github.com/blueswen/grafana-zero-to-hero/raw/main/use-case/grafana-llm/llm-demo-01.png)


你可以直接在介面上問 AI：「為什麼這個服務會報警？」

![](https://github.com/blueswen/grafana-zero-to-hero/raw/main/use-case/grafana-llm/llm-demo-02.png)

最讓我 Shock 的是，串接 Github MCP 後，還可以**請 AI 直接分析問題點的程式碼在哪裡**，連 Code 都幫你找出來了

![](https://github.com/blueswen/grafana-zero-to-hero/raw/main/use-case/grafana-llm/llm-demo-03.png)

### 內部 Domain 知識怎麼辦？

如果公司有自己的 Domain 知識，原本想說是不是要自建 RAG (Retrieval-Augmented Generation)，但講者提到自建 RAG 系統會太肥重。這邊推薦使用 [Claude Skills](https://www.claude.com/blog/skills)，相對輕量很多。

### Q&A 精華

* **Q: Dashboard 太多了如何管理？**
* **A:** 建議做一個 Over all 的 Dashboard，然後裡面用 Link 連出去，不要全部塞在同一個地方。

* **Q: Dashboard 偏視覺化，多人有權限修改時很容易壞掉，是否可以版控？**
* **A:** 可以使用 Grafana Git Sync，或者等 IaC (如 Terraform provider for Grafana) 更加成熟後用語法來管理。

* **Q: 如何備份？**
* **A:** 單一 Dashboard 備份 JSON 即可；整個 Grafana 資料庫預設是 SQLite，直接備份檔案就行。另外也有第三方 App 可以 Dump IaC 格式出來。

---

## 《建構多租戶 SaaS 架構》新書導讀：從混亂到秩序

![](/public/img/post/devops-taiwan/74/1.jpg)

第二場講的是 SaaS 架構。做產品跟做 SaaS 的思維完全不同，講者提到一個很棒的比喻：

如果只從「產品」角度思考，那是**平面**的：我們只想著「如何實現這個功能」。
但 SaaS 是**第三維**的：當你的租戶量來到 1,000 個時，你要面對的是資料隔離、Log 爆炸、各國法規等立體的問題。

### SaaS 架構的四大難點

轉型 SaaS，一定會撞到這四道牆：

1. **安全 (Security)**
* **痛點**：機敏資料隔離。如果只是在 Query 時加上 `WHERE tenant_id = xxx`，工程師手滑忘記加就會造成不同租戶資料互通，嚴重的話更會牽涉機敏資料外洩。
* **Trade-Off**：Silo Model (獨佔資源) vs. Pool Model (共享資源) 各有優缺點。

2. **效能 (Performance)**
* **痛點**：Noisy Neighbor（吵鬧的鄰居）。單一租戶高負載，把 CPU/DB/記憶體 吃光，導致其他正常租戶卡頓。
* **Trade-Off**：預留資源 vs. 動態配置。

3. **擴展性 (Scale)**
* **痛點**：為了配合不同客戶的客製化，程式碼出現各種 if-else 地獄。
* **Trade-Off**：Static Config vs. Real-time Config。

4. **維運 (Operations)**
* **痛點**：Unit Economics（單位經濟效益）失靈。很難算清楚每個租戶到底花了你多少雲端成本。
* **Trade-Off**：Manual tagging vs Auto injection

### 解決方向與架構拆分

為了應對這些問題，架構上需要切成兩種不同層級：**Control Plane（控制層）**與 **Application Plane（應用層）**。

* **安全解法**：建立 Central Identity Service（中心化身分驗證）。
* **效能解法**：利用 API Gateway 去切分不同的資源池。
* **擴展解法**：善用 Feature Toggle（功能開關）。
* **維運解法**：落實詳細的 Metric 收集。

> **"Architecture is the business model."** > 架構即商業模式。Control Plane 的存在是為了實現分層策略 (Tiering)，系統應依照不同租戶的付費方案，配置不同的資源。

### 既有產品要轉換成 SaaS 的三步驟

如果你手上已經有現成的產品要上雲轉 SaaS，講者建議的順序是：

1. **身份認證 (Identity)**：先搞定租戶識別。
2. **等級切分 (Tiering)**：定義不同價位的功能與資源。
3. **自動化 (Automation)**：自動開通、自動擴縮容。

*補充：AI 帶來的新挑戰是，未來的 AI Agent 可以 access 到多底層的資料？這會是新的資安與架構考驗。*

### Q&A 精華

* **Q: 在 Share Pool 架構下，遇到惡意（或用量超大）的用戶佔用資源怎麼辦？**
* **A:** 講者的實務案例：
1. **個案處理**：有個客戶每個月底都會下載超大報表，這時就靠腳本自動幫他「特別開一台機器」，跑完就關掉，不影響其他用戶。
2. **機制防禦**：API Gateway 的 Rate-limit 一定要設計好。

* **Q: SaaS 的計價問題怎麼算？**
* **A:** 國外大廠很多都用「點數 (Credit)」制。好處是底層計算方式可以**比較黑箱**，廠商精算後再轉換成點數賣給客戶（這招真的很賊 XD）。

---

## 結語

每次參加 AI 有關的 Meetup 都會發現工具迭代速度之快，基本可以想像未來簡單重複性高又或是 RD 最懶得做的工作都會被 AI 給取代掉
