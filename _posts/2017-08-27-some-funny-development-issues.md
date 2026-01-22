---
layout: post
title: 專案開發問題集!~
tagline: Some funny development issues
description: 這邊用來存放些開發時遇到的奇葩問題 (´c_`)
author: VagrantPi
tags: funny environment
---

專案的進行中難免會遇到些問題，這篇用來記錄些花費多時最後發現的奇葩問題 (´c_`)

## 環境篇

### 環境 build 不起來

公司專案使用 grunt 來編譯環境，不過我是來試去始終 run 不起來

```shell
Running "bower:dev" (bower) task
>> Cleaned target dir /專案位置/assets/bower
>> Installed bower packages
>> Copied packages to /專案位置/assets/bower

Running "bower:dev" (bower) task
>> Cleaned target dir /專案位置/assets/bower
>> Installed bower packages
>> Copied packages to /專案位置/assets/bower

Running "clean:dev" (clean) task

Running "jst:dev" (jst) task
>> Destination not written because compiled files were empty.

Running "sass:dev" (sass) task
ERROR: Cannot load compass.
Warning: Exited with error code 1 Use --force to continue.

Aborted due to warnings.
npm ERR! code ELIFECYCLE
npm ERR! errno 6
npm ERR! myproject@1.6.0 build-dev: `grunt dev`
npm ERR! Exit status 6
npm ERR! 
npm ERR! Failed at the myproject@1.6.0 build-dev script.
npm ERR! This is probably not a problem with npm. There is likely additional logging output above.

npm ERR! A complete log of this run can be found in:
npm ERR!     /home/pi/.npm/_logs/2017-08-27T10_28_15_605Z-debug.log
```

這 Error 看起來是在跑 "jst:dev" 時找不到檔案，導致到 "sass:dev" 出現 ERROR，或是 compass 沒裝

花了一整個下午找問題，後發現了問題是我的 SASS 版本太新了(WTF!!!!!!!!!!!)

```shell
gem uninstall sass
gem install sass -v 3.4.25
```

這問題真的頗雷的 ╮(╯_╰)╭


### 環境套件裝不起來

```shell
npm i
```

安裝出現 Error，不過 yarn 卻可以跑完安裝 (´ﾟдﾟ`)

```
npm -g install npm@5.3.0
```

降版後就解決了


更新中~~~~


