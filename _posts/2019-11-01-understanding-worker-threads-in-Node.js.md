---
layout: post
title: "Understanding Worker Threads in Node.js"
subtitle: Understanding Worker Threads in Node.js
description: "Node.js 優化 CPU 用蒜效能的實驗性解決方案"
author: VagrantPi
tags: Node.js JavaScript
imgurl-fb: /public/img/index/nodejs.jpg
imgurl: /public/img/index/nodejs.jpg
image: /public/img/index/nodejs.jpg
imgalt: nodejs 
---

## 前言

過了很久沒更新文章了，剛好最近看到一篇介紹 Node.js worker_threads 文章

筆記作著作著不小心快變翻譯了，所以直接連絡作者了 XD

文章如有任何問題請提出指點，謝謝

```
本文章轉載於 https://nodesource.com/blog/worker-threads-nodejs/
已經過作者同意，請勿亂轉載，謝謝
```

在講解 worker 前必須先提到 Node.js 的知識：

## about Node.js

- One process
	
	一個全域的 Object，可以在任何地方被執行，並保有執行時的資料

- One thread

	single-threaded，在一個	process 中只能執行一個件事
	
- One event loop

	對於了解 Node.js 來說很重要，它使 Node.js 可以是 asynchronous 且 non-blocking I/O。Node.js 是 single-threaded 的，通過 callbacks, promises 和 async/await 能將工作分散給 system kernel

- One JS Engine Instance

	執行 Javascript code
	
- One Node.js Instance

	執行 Node.js code

總結來說，Node.js 為 single-threaded，也就是同一時間只會有一個 process 在 event loop 中(code 不能 parallel 的被執行)。這對 concurrency 之類的問題來說很好處理

之所以為這樣的架構，因為一開始 Javascript 為 client-side 互動用(互動會驗證表單)，所以也不需要用到 multithreading

但這也有缺點，當你需要 CPU 進行大量運算時，它會 block 住，其他 processes 只能等他， 同樣的如果你發起一個 request 要求 server 做大量運算，他也會在那邊 block 住等待它的 response

如果有 function 阻礙主程式的 event loop，並使主程式等待其完成，該 function 稱為 “blocking” function，而 “Non-blocking” function 則會保持主程式的 event loop 持續運作，直到工作做完才告訴主程式他完成了，這就是常見的 “callback“ function

> 黃金法則：不要阻塞(block) event loop，避免任何可能 blocking 的事件，如 synchronous 網路或呼叫無窮迴圈

區分 CPU 操作與 I/O (input/output) 操作是重要的，只有 I/O 操作能併行(parallel)執行，但還記得我們前面說的 Node.js 不能併行(parallel)執行吧

所以 Worker Threads 來處理大量的 I/O 處理效益不高，Worker Threads 的目標是為了提高 CPU 的操作效能

## Some solutions

在此 Worker Threads 出現之前，大量的 CPU 運算也是有些解決方案的，通過 multiple processes (like cluster API)，可以充分的使用 CPU

這種方法可以隔離各個 processes，當某一個 process 出問題時並不會影響其他 process，但也因此無法掉共享記憶體，因此在跨 process 傳輸資料時需要通過 JSON 來傳輸

## JavaScript and Node.js will never have threads, this is why:

所以普遍認為在 Node.js 核心增加新模組來達到新建和同步 threads，可以有效解決大量的 CPU 運算問題

但是新增後將會直接改變其語言特性，而且不是是單純的將 class 或 function 放上 thread(容易出現 race condition 問題)，在其他支援 multithreading 的語言(如 JAVA)，可以通過 synchronized 的方式來處理 multithread 的同步問題

另外一些數字型態並不是原子性的，代表如過你不同步的處理它，他可能在多個 threads 都 access 它後，導致數字遭到一些改動，如下

`var x = 0.1 + 0.2; // x will be 0.30000000000000004`

浮點數運算不是很準確，有可能使用 Worker 改動到某個小數，而導致輸出不一致

## The best solution:

增加 CPU 運算效能的最佳方案為 Worker Threads，瀏覽器有存在該概念一段時間了

原先：

- One process
- One thread
- One event loop
- One JS Engine Instance
- One Node.js Instance

Worker threads have:

- One process
- Multiple threads
- One event loop per thread
- One JS Engine Instance per thread
- One Node.js Instance per thread

![](/public/img/post/nodejs/worker-diagram.jpg)

通過 `worker_threads` module 可以使你的 Javascript 併行(parallel)執行

```javascript
const worker = require('worker_threads');
```

不過 node.js 在 v10.5.0 版本後加入了該模組，不過處於實驗性質，所以在下 command 時，需加上 `--experimental-worker` 參數(新版本已經支援了，可以看下面的補充)

原本的多個 Node.js instances 跑在同一個 process。而在使用 Worker threads 時，Node.js 會建立新的 threads 並將 Node.js instances 跑在裡面

接下來來看看 Worker Threads 有哪些特別的東西：

- `ArrayBuffers` 可以在 threads 間傳遞記憶體空間
- `SharedArrayBuffer` 可以無障礙的在 threads 間分享記憶體(只能是 binary data)
- `Atomics` 允許你在多線程中安全的使用變數
- `MessagePort` asynchronous 的通訊端，用於不同 threads 間傳遞的資料用
- `MessageChannel` 可以在兩個 threads 間 asynchronous 的傳遞資料
- `WorkerData` 傳遞的資料型態，為任意 Javascript 資料型態

API

- `const { worker, parentPort } = require(‘worker_threads’)` => `worker` 代表獨立的 thread、`parentPort` 則是 instance 的 port
- `new Worker(filename)` or `new Worker(code, { eval: true })` => 兩種啟動 worker 的方法(傳送 filename 或要執行的 code)，建議在 production 使用 filename
- `worker.on(‘message’)`, `worker/postMessage(data)` => listening message 並將它傳到其他 threads
- `parentPort.on(‘message’)`, `parentPort.postMessage(data)` => `parentPort.postMessage` 傳送資料，父 thread 使用 `worker.on('message')` 取得資料。父 thread 使用 `worker.postMessage()` 傳送資料，`parentPort.on('message')`取得資料。
## EXAMPLE

```javascript
const { Worker } = require('worker_threads');

const worker = new Worker(`
const { parentPort } = require('worker_threads');
parentPort.once('message',
    message => parentPort.postMessage({ pong: message }));  
`, { eval: true });
worker.on('message', message => console.log(message));      
worker.postMessage('ping');  
```

```shell
$ node --experimental-worker test.js
{ pong: ‘ping’ }
```

建立一個 worker 來起一個新的 thread，並在 thread 中使用 parentPort 等待接收 message，當接收到時會將他發送到 main thread

Another example:

```javascript
const {
  Worker, isMainThread, parentPort, workerData
} = require('worker_threads');

if (isMainThread) {
  module.exports = function parseJSAsync(script) {
    return new Promise((resolve, reject) => {
      const worker = new Worker(filename, {
        workerData: script
      });
      worker.on('message', resolve);
      worker.on('error', reject);
      worker.on('exit', (code) => {
        if (code !== 0)
          reject(new Error(`Worker stopped with exit code ${code}`));
      });
    });
  };
} else {
  const { parse } = require('some-js-parsing-library');
  const script = workerData;
  parentPort.postMessage(parse(script));
}
```

- `isMainThread` 當 code run 在 Worker thread 時為 true
- `parentPort` MessagePort 可以與 parent thread 進行溝通(由 Worker 產生的新 thread)

在實務上，請使用 pool of Workers instead，不然建立 Workers 的開銷可能超出其收益

## What is expected for Workers (hopefully)

- Passing native handles around (e.g. sockets, http request)
- Deadlock 檢測
- more isolation, 當其中一個 process 出問題時並不會影響其他 process

## What NOT to expect for Workers:

- 不要覺得使用了就會很快，在某些情況下請使用 Worker pool
- 別使用 Workers 在併行(parallelizing) I/O 處理.
- 產生 Workers 也需要丟失些效能

## Final notes:

可以在 [這裡](https://github.com/nodejs/worker/issues/6) 看到 Workers 相關的 feedback(目前還屬於實驗性質)

如果你需要在 Node.js 處理大量的運算，目前還不建議 production 中

## 更新

根據 FB Backend 社團大大提供的消息

work_thread 已經 LTS v12.13.0 後的版本支援了，不再是實驗性功能，所以下 command 時不需要加上 `--experimental-worker`


