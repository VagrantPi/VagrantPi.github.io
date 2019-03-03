---
layout: post
title: "Design Pattern 筆記 - Adapter Pattern"
subtitle: 圖解設計模式讀書筆記 - Adapter Pattern
description: "Adapter Pattern 筆記"
author: VagrantPi
tags: Design_Pattern Note
imgurl-fb: /public/img/index/gopher-fb.jpg
imgurl: /public/img/index/gopher.jpg
imgalt: gopher 
---

## 前言

上次文章直接丟到 Golang FB 社團果然瀏覽數飆高(FB 資訊圈朋友太少之前自己 PO 文也都是自嗨 (つд⊂))

不過我自己閉門造車果然也出現很多問題，剛貼過去社團就有人發現 interface 完全沒作用，最後也發現註解跟說明實在太少了

看來筆記的整理技術要在多下點功夫了，那接下來來一起看看新的 Pattern 吧

## Adapter Pattern

試想一下，當你想要直流電的電器用品（規格Ａ），在交流電 110V（規格Ｂ）的供電下運作，通常都需要接上交流配接器(AC adapter)，才能使我們的小家電也能在 110V 或 220V 下運作

Adapter Pattern 也被稱為 Wrapper Pattern，替我們將 A 包裝成 B 可以使用的形狀

然後又可以分成下面兩種：

- Object Adapter (使用 delegation)
- Class Adapter (使用繼承)

下面範例為：

輸入一段文字(Hello)，程式會呼叫兩個 func 來印出兩行文字

```
(Hello)
*Hello*
```

class `Banner`(規格Ｂ)，分別有 `ShowWithParen()`、`ShowWithAster()` 兩 func

而 `Print` interface(規格Ａ) 也定義了兩個 func `PrintWeek()`、`PrintStrong()`，想要直接接上 class `Banner` 的兩種 func

> 一樣的本書使用的是 java 當範例，所以我一起附上了

## Object Adapter

### Class Diagram

![Adapter Pattern(Object)](/public/img/post/design_pattern/adapter_pattern(object).jpg)

name | descreption
-----|------------
Print | Print class(規格Ａ)
PrintBanner | extends Print(Adapter)
Banner | Banner class(規格Ｂ)

### 範例一

#### Banner

java:

```java
public class Banner {
  private String string
  public Banner(Strign string) {
    this.string = string;
  }
  public void showWithParen() {
    System.out.println("(" + string + ")")
  }
  public void showWithAster() {
    System.out.println("*" + string + "*")
  }
}
```

go:

```go
type Banner struct {
	bannerString string
}

func (b *Banner) Banner(s string) {
	b.bannerString = s
}

func (b *Banner) ShowWithParen() {
	fmt.Printf("(%v)\n", b.bannerString)
}

func (b *Banner) ShowWithAster() {
	fmt.Printf("*%v*\n", b.bannerString)
}
```

#### Print

java:

```java
public abstract class Print {
  public abstract void printWeek();
  public abstract void printStrong();
}
```

go:

這邊的 Print class 是定義好需要的方法後再讓 PrintBanner 繼承，因為 golang 沒繼承，所以這邊就沒做了

#### PrintBanner

java:

```java
public class PrintBanner extends Print {
  private Banner banner;
  public PrintBanner(String string) {
    this.banner = new Banner(string)
  }
  public void printWeek() {
    banner.showWithParen()
  }
  public void printStrong() {
    banner.showWithAster()
  }
}
```

go:

```go
// PrintBanner 繼承 Print
// 因為 golang 中並沒有繼承，所以這邊使用 Embedding struct 來實作
type PrintBanner struct {
	banner.Banner
}

func (b *PrintBanner) PrintBanner(s string) {
	b.Banner.Banner(s)
}

func (b *PrintBanner) PrintWeek() {
	b.Banner.ShowWithParen()
}

func (b *PrintBanner) PrintStrong() {
	b.Banner.ShowWithAster()
}
```

#### Main

java:

```java
public class Main {
  public static void main(String[] args) {
    Print p = new PrintBanner("Hello")
    p.PrintWeek()
    p.PrintStrong()
  }
}
```

go:

```go
func main() {
	pb := &model.PrintBanner{}
	pb.PrintBanner("Hello")
	// 透過 PrintBanner(adapter) 可以直接使用 Banner(規格 B)的方法
	pb.PrintWeek()
	pb.PrintStrong()
}
```


## Class Adapter

### Class Diagram

![Adapter Pattern(Class)](/public/img/post/design_pattern/adapter_pattern(class).jpg)

name | descreption
-----|------------
Print | Print interface(規格Ａ)
PrintBanner | Print instance, extends Banner(Adapter)
Banner | Banner class(規格Ｂ)

golang 沒有繼承，所以這邊就不實作了，直接看看 java code 來感受一下兩者的差別吧

### 範例二

#### Banner

java:

```java
public class Banner {
  private String string
  public Banner(Strign string) {
    this.string = string;
  }
  public void showWithParen() {
    System.out.println("(" + string + ")")
  }
  public void showWithAster() {
    System.out.println("*" + string + "*")
  }
}
```


#### Print

java:

```java
public abstract interface Print {
  public abstract void printWeek();
  public abstract void printStrong();
}
```

#### PrintBanner

java:

```java
public class PrintBanner extends Banner implements Print {
  public PrintBanner(String string) {
    super(string)
  }
  public void printWeek() {
    showWithParen()
  }
  public void printStrong() {
    showWithAster()
  }
}
```

#### Main

java:

```java
public class Main {
  public static void main(String[] args) {
    Print p = new PrintBanner("Hello")
    p.PrintWeek()
    p.PrintStrong()
  }
}
```

## Adapter 中登場的角色

- Target(對象)

    定義著所需要的方法(即最上面所提到的電器用品需要的直流電電源)，在範例中為 Print interface 和 Print struct 

- Client(請求者)

    即負責使用 Target 實現的功能(直流電的電器，如筆電)，在範例中為 Main

- Adaptee(被 adapter)

    為既有的方法(原本就有的交流電)，在範例中為 Banner struct
    而如果 Adaptee 的方法與 Target 相同(即原本的插孔就是直流電了)，這樣就不需要 Adapter 角色了

- Adapter

    滿足 Target 的需求(讓交流電插座可以被直流電電器所使用)，在範例中為 PrintBanner


## So Why?

### 使用時機

也許你會這樣想，為何不直接呼叫需要的方法就好，而是透過 adapter 替我們去呼叫呢？

這邊書中解釋為

- Adapter Pattern 會對現有的 class(Adaptee) 配接(adapter)成新的 class 和方法，而現有的 class 也許已經做過充分的 test 且 bug 很少，所以當 Bug 出現時，直椄找 Adapter 就好

- 有些時候 Adaptee 只有大部分符合 Target 需求，但還是有寫需要修修改改的地方，如果直接從 Adaptee 修改，也許原本的 Adaptee 測試也要一起更動到，而使用 Adapter Pattern 就可以不需要更動到 Adaptee 的 code 了

- 新舊版本兼容問題，假設今天我們只想維護新版，這時我們可以讓新版本擔任 Adaptee 角色，叫舊版本擔任 Target，讓它使用新版本的 class 來實現舊版本的 class 中的方法
  ![Adapter Pattern(sample)](/public/img/post/design_pattern/adapter_pattern(sample).jpg)

## 練習題

"github.com/magiconair/properties" 可以用來管理 key-value 集合（書中是用 java.util.Properties，所以我也上網找了個 golang 版本的來）

```
year=2019
month=1
day=13
```

請使用 Adapter Pattern 將 input.txt 中的 key-value 集合保存至文件中的 FileProperties class，FileProperties 為 FileIO(Target 角色) 的 implementation，然後經過一些修改後存成 newfile.txt

FileIO:

```go
type FileIO interface {
	ReadFile(fileName string)
	WriteToFile(fileName string)
	SetVale(key, value string)
	GetValue(key string)
}
```

main:

```go
func main() {
	var fp model.FileIO = &model.FileProperties{}
	fp.ReadFile("./input.txt")
	fp.SetVale("year", "2019")
	fp.SetVale("month", "1")
	fp.SetVale("day", "13")
	fp.WriteToFile("newfile.txt")
}
```

input.txt

```
year=1999
```

newfile.txt

```
# written by FileProperties
# Sun, 13 Jan 2019 17:03:09 CST1999
day=13
year=2019
month=1
```

## 解答

> https://github.com/VagrantPi/golang-design-pattern/tree/master/2.adapter/practice

基本上 Target 可以在完全不知道 "github.com/magiconair/properties" 的方法的情況下使用它，因為已經被我們包裝成 FileIO 了

## 結語

> 文中的 Source Code 都放在 [github](https://github.com/VagrantPi/golang-design-pattern/tree/master/2.adapter) 了，自己 clone 下來玩玩吧

還好上一篇沒說要每週一篇文章 (つд⊂)，書越看就發現要學的東西還很多

Adapter Pattern 我覺得用法比較常見，之前把 aws-sdk-go 的上傳 s3 功能包裝簡單的方法 ，讓同事不用清楚知道 aws-sdk-go 的情況下簡單操作(這概念也算是吧？ XD)

感謝 FB Golang 社團一些大大的建議，沒想到有人認真看找到了些問題 ＱＱ，之後應該也會找時間把我 hackmd 上的技術筆記慢慢的變成 blog 的文章貼過來吧，~~不過想想又好懶~~



## 系列文章

- [Design Pattern 筆記 - Iterator Pattern]({{ site.url }}/2019/01/01/design-pattern-iterator/)
- [Design Pattern 筆記 - Adapter Pattern]({{ site.url }}/2019/01/07/design-pattern-adapter/)
- [Design Pattern 筆記 - Template Pattern]({{ site.url }}/2019/01/28/design-pattern-template/)
- [Design Pattern 筆記 - Singleton Pattern]({{ site.url }}/2019/03/03/design-pattern-singleton/)
