---
layout: post
title: "Design Pattern 筆記 - Singleton Pattern"
subtitle: 圖解設計模式讀書筆記 - Singleton Pattern
description: "Singleton Pattern 筆記"
author: VagrantPi
tags: Design_Pattern Note
imgurl-fb: /public/img/index/gopher-fb.jpg
imgurl: /public/img/index/gopher.jpg
imgalt: gopher 
---

## 前言

躺著過完年，接著又是連假，拖延症發作了 \_(:3 」∠ )\_

然後工廠模式實作上卡卡的 (;ﾟдﾟ)，只好先跳下一章來看，所以範例直接跳過一張

決定再買本書來翻翻了，OOP 大學該認真學的 ｡ﾟヽ(ﾟ´Д`)ﾉﾟ｡

## Singleton Pattern

> 只有一個實例(instance)

程式在運行時，通常會產生很多實例，但有些時候“只能建立一個實例”，書中舉例是軟體的系統設定相關的 class，或是視窗系統(window system)的 class，所以該 pattern 用來確保任何情況下絕對只有一個實例

## 範例說明

這個 pattern 很簡單，範例中產生兩個 instance 並確定為同一個 

name | description
-----|--------------
Singleton | 只存在一個實例
Main | 測試用

### Class Diagram

![singleton Class Diagram](/public/img/post/design_pattern/singleton_pattern.jpg)

## Java code

### Singleton

```java
public class Singleton {
  private static Singleton singleton = new Singleton();
  private Singleton() {
    System.out.println("產生一個 instance");
  }
  public static Singleton getInstance() {
    return singleton;
  }
}
```

### Main

```java
public class Main {
  public static void main(String[] args) {
    System.out.println("Start.");
    Singleton obj1 = Singleton.getInstance();
    Singleton obj2 = Singleton.getInstance();
    if (obj1 == obj2) {
      System.out.println("obj1 與 obj2 是相同的 instance");
    } else {
      System.out.println("obj1 與 obj2 是不相同的 instance");
    }
    System.out.println("End.");
  }
}
```

```
Start.
產生一個 instance
obj1 與 obj2 是相同的 instance
End.
```

## Golang 

### Singleton

```go
package model

import "fmt"

type singletonOP interface {
	Count()
	Get() int
}

type singleton struct {
	count int
}

func (s *singleton) Count() {
	s.count++
}

func (s *singleton) Get() int {
	return s.count
}

func (s *singleton) singleton() {
	fmt.Println("create a instance.")
}

var instance *singleton

func GetInstance() *singleton {
	if instance == nil {
		instance = &singleton{}
		instance.singleton()
	}
	return instance
}
```

### Main

```go
package main

import (
	"fmt"

	"5.singleton/model"
)

func main() {
	fmt.Println("start.")
	instanc1 := model.GetInstance()
	instanc1.Count()
	instanc1.Count()
	instanc2 := model.GetInstance()

	fmt.Println("instanc1 count is:", instanc1.Get())
	fmt.Println("instanc2 count is:", instanc2.Get())
	fmt.Println("end.")
}
```

```
start.
create a instance.
instanc1 count is: 2
instanc2 count is: 2
End.
```

## Singleton Pattern 中登場的角色

- Singleton(抽象類)

    在 Singleton Pattern 中只有一個角色，永遠回傳同一個實例

## so why?

聰明的你可能會想那為何需要在 golang 實現 Singleton Pattern，一個 package 的 public 變數不也是 Singleton 了嗎？（FB 社團有人提到），我個人的想法是為了解決 concurrency 問題，不過照原本寫法會是有問題的 (つд⊂)

改寫一下 Singleton：

```go
package model

import (
	"fmt"
	"sync"
)

type singletonOP interface {
	Count()
	Get() int
}

type singleton struct {
	count int
}

func (s *singleton) Count() {
	s.count++
}

func (s *singleton) Get() int {
	return s.count
}

func (s *singleton) singleton() {
	fmt.Println("create a instance.")
}

var instance *singleton
var once sync.Once

func GetInstance() *singleton {
	once.Do(func() {
		instance = &singleton{}
		instance.singleton()
	})
	return instance
}
```

> 參考了這篇，裡面還嘴了我第一種寫法 (つд⊂) [link](http://marcio.io/2015/07/singleton-pattern-in-go/?fbclid=IwAR3QjiQdyWcyGm5j2Qft59_rjO9kG3UZGjSts0zKjXiOSU9OP_mvvGhh7as)


## 結語

> 文中的 Source Code 都放在 [github](https://github.com/VagrantPi/golang-design-pattern/tree/master/5.singleton) 了，自己 clone 下來玩玩吧

看來我當初如果報名鐵人賽應該也中途就斷了 XD

~~未來改成一個月一篇好了~~

如果有任何問題或錯誤歡迎幫忙指正，謝謝


## 系列文章

- [Design Pattern 筆記 - Iterator Pattern]({{ site.url }}/2019/01/01/design-pattern-iterator/)
- [Design Pattern 筆記 - Adapter Pattern]({{ site.url }}/2019/01/07/design-pattern-adapter/)
- [Design Pattern 筆記 - Template Pattern]({{ site.url }}/2019/01/28/design-pattern-template/)
- [Design Pattern 筆記 - Singleton Pattern]({{ site.url }}/2019/03/03/design-pattern-singleton/)




