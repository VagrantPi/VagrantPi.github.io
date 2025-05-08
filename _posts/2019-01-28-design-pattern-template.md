---
layout: post
title: "Design Pattern 筆記 - Template Pattern"
subtitle: "Golang 實踐設計模式 - Template Pattern"
description: "Template Pattern 是一種行為設計模式，讓我們可以定義演算法的骨架，但將一些步驟延遲到子 class 實踐。透過 Golang 實踐設計模式，讓我們更容易理解這個模式，並應用在實際開發中。"
author: VagrantPi
tags: Design_Pattern Golang
imgurl-fb: /public/img/index/gopher-fb.jpg
imgurl: /public/img/index/gopher.jpg
image: /public/img/index/gopher.jpg
imgalt: gopher 
---

## 前言

每次發文都還是都能被找到錯誤 Σ(ﾟДﾟ；≡；ﾟдﾟ)

如果跟我一樣是新米 Gopher 可以等文章發完過幾天再上來看，說不定又會有熱心的大大幫忙 review 了 ORZ

很感謝 Golang Taiwan 板上的大大不吝指教，每次討論與指正都讓我學到了一些東西

## Template Pattern

> 將具體處理交給子類

Template 就如下面這種工具

![template](/public/img/post/design_pattern/template.jpg)

雖然我們可以從鏤空的洞看出能寫出什麼文字，但具體字出來會長怎樣還是依賴於所用的筆(e.g. 彩色、鉛筆色、墨水色)，但無論使用哪種筆，最後產出的文字都是一樣的

下面範例因為 golang 沒有 class 與繼承，所以實作上差很多(也說不定是我寫錯了 XD)，所以會先上個 Java code，配合著 Class Diagram 感受一下，之後才是 Golang 版本，那就不廢話了直接進 code 吧

## 範例說明

`AbstractDisplay class` 定義了 display 方法，並在該方法中呼叫 open, print, close 這 3 個方法，不過這 3 個方法在 `AbstractDisplay class` 中只有選告並未實作(抽象方法)，在這邊呼叫抽象方法的 display 就是模板(template)方法 

name | description
-----|--------------
AbstractDisplay | 只實現 display 方法的抽象 class
CharDisplay | 實現了 open, print, close 方法的 class
StringDisplay | 實現了 open, print, close 方法的 class

### Class Diagram

![template Class Diagram](/public/img/post/design_pattern/template_pattern.jpg)

## Java code

### AbstractDisplay

這邊我們定義了display(模板)長怎樣、及一些抽象方訪

- 呼叫 open()
- 呼叫 print() 5 次
- 呼叫 close()

```java
public abstract class AbstractDisplay {
  public abstract void open();   // 交給子 class 實現的抽象方法
  public abstract void print();  // 交給子 class 實現的抽象方法
  public abstract void close();  // 交給子 class 實現的抽象方法
  public final void display() {
    open()
    for (int i = 0; i < 5; i++) {
      print();
    }
    close();
  }  
}
```

### CharDisplay

這個子 class 實現了父 class 的三種方法，分別為

name | description
-----|-------------
open | 印出 "<<"
print | 印出建構函式接收到的一個字符
close | 印出 ">>"

e.g. 當我們使用建構函示塞進 "H" 參數後，display 會印出

```
<<HHHHH>>
```

```java
public class CharDisplay extends AbstractDisplay {
  private char ch;
  public CharDisplay(char ch) {
    this.ch = ch;
  }
  public void open() {
    System.out.print("<<");
  }
  public void print() {
    System.out.print(ch);
  }
  public void close() {
    System.out.println(">>");
  }
}
```

### StringDisplay

name | description
-----|-------------
open | 印出 "+-----+"
print | 印出建構函式接收到的字串，並在前後加上 "|"
close | 印出 "+-----+"

e.g. 當我們使用建構函示塞進 "Hello, world!" 參數後，display 會印出

```
+----------------+
| hello, world ! |
| hello, world ! |
| hello, world ! |
| hello, world ! |
| hello, world ! |
+----------------+
```

```java
public class StringDisplay extends AbstractDisplay {
  private String string;
  private int width;

  public StringDisplay(String string) {
    this.string = string;
    this.width = string.getBytes().length;
  }
  public void open() {
    printLine();
  }
  public void print() {
    System.out.print("| " + string + " |");
  }
  public void close() {
    printLine();
  }
  public void printLine() {
    System.out.print("+")
    for (int i = 0; i < width; i ++) {
      System.out.print("-")
    }
    System.out.println("+")
  }
}
```

### Main

```java
public class Main{
  public static void main(String[] args) {
    AbstractDisplay d1 = new CharDisplay('H');
    AbstractDisplay d2 = new StringDisplay("Hello, world.");
    AbstractDisplay d2 = new StringDisplay("Template Pattern.");
    d1.display();  // d1, d2, d3 都是 AbstractDisplay 的子 class
    d2.display();  // 可以呼叫繼承的 display 方法
    d3.display();  // 實際上的行為，取決於子 class 的具體實現
  }
}
```

output:

```
<<HHHHH>>
+---------------+
| Hello, world. |
| Hello, world. |
| Hello, world. |
| Hello, world. |
| Hello, world. |
+---------------+
+-------------------+
| Template Pattern. |
| Template Pattern. |
| Template Pattern. |
| Template Pattern. |
| Template Pattern. |
+-------------------+
```

## Golang 

### AbstractDisplay

在 golang 當中，並沒有 class 與繼承，因此我們將呼叫抽象方法的 Display 而寫成另一個 interface `AbstractDisplayTemplate`，並在這邊時做了兩種模版 `AbstractDisplayTemplateStruct1`, `AbstractDisplayTemplateStruct2`

```go
type AbstractDisplay interface {
	Open()
	Print()
	Close()
}

type AbstractDisplayTemplate interface {
	Display(AbstractDisplay)
}

type AbstractDisplayTemplateStruct1 struct{}

func (a *AbstractDisplayTemplateStruct1) Display(ad AbstractDisplay) {
	ad.Open()
	ad.Print()
	ad.Close()
}

type AbstractDisplayTemplateStruct2 struct{}

func (a *AbstractDisplayTemplateStruct2) Display(ad AbstractDisplay) {
	ad.Open()
	for i := 0; i < 5; i++ {
		ad.Print()
	}
	ad.Close()
}
```

### CharDisplay

```go
type CharDisplate struct {
	Char string
}

func (c CharDisplate) Open() {
	fmt.Printf("<<")
}

func (c CharDisplate) Print() {
  // Char 為 string，不過這個方法只印出第一個字元，所以多了下面的判斷式
	if len(c.Char) != 0 {
		fmt.Printf(c.Char[0:1])
		return
	}
	fmt.Printf("")
}

func (c CharDisplate) Close() {
	fmt.Println(">>")
}
```

### StringDisplay

```go
type StringDisplate struct {
	String string
}

func (c StringDisplate) Open() {
	c.PrintLine()
}

func (c StringDisplate) Print() {
	fmt.Println("+ " + c.String + " +")
}

func (c StringDisplate) Close() {
	c.PrintLine()
}

func (c StringDisplate) PrintLine() {
	fmt.Printf("+")
	for i := 0; i < len(c.String)+2; i++ {
		fmt.Printf("-")
	}
	fmt.Println("+")
}
```

### Main

```go
func main() {
	var data1 model.AbstractDisplay = &model.CharDisplate{"H"}
	var data2 model.AbstractDisplay = &model.StringDisplate{"Hello, world!"}
	var data3 model.AbstractDisplay = &model.StringDisplate{"Template Pattern!"}
	var tmpl1 model.AbstractDisplayTemplate = &model.AbstractDisplayTemplateStruct1{}
	var tmpl2 model.AbstractDisplayTemplate = &model.AbstractDisplayTemplateStruct2{}
	fmt.Println("template 1")
	tmpl1.Display(data1)
	tmpl1.Display(data2)
	tmpl1.Display(data3)
	fmt.Println("\n==============================\n")
	fmt.Println("template 2")
	tmpl2.Display(data1)
	tmpl2.Display(data2)
	tmpl2.Display(data3)
}
```

output: 

```
template 1
<<H>>
+---------------+
+ Hello, world! +
+---------------+
+-------------------+
+ Template Pattern! +
+-------------------+

==============================

template 2
<<HHHHH>>
+---------------+
+ Hello, world! +
+ Hello, world! +
+ Hello, world! +
+ Hello, world! +
+ Hello, world! +
+---------------+
+-------------------+
+ Template Pattern! +
+ Template Pattern! +
+ Template Pattern! +
+ Template Pattern! +
+ Template Pattern! +
+-------------------+
```

## Template Pattern 中登場的角色


- AbstractClass(抽象類)

    負責實現模板方法，並宣告模板中所使用的抽象方法，為 Class Diagram 圖中的 AbstractDisplay

- ConcreteClass(具體類)

    實現 AbstractClass 定義的抽象方法，這邊實現的方法會在 AbstractClass 中被呼叫

## So Why?

### 使邏輯處理通用化

其優點在於，一樣的方法不需要不段的實現，用 golang 例子來看，如果 AbstractDisplay interface 多定義了 Display 的話，這樣所有的實例都需要在多實現 Display，但是這邊範例的需求上所以 display 的行為都是一樣的(所以在父 class 被實現就好了)

### 父類與子類的一至性

這邊以 java code 來看，`CharDisplay`、`StringDisplay` 的 instance 都是存成 `AbstractDisplay` 的變數，無論 `AbstractDisplay` 現在存的是哪一個子類，都可以正常的工作，這種原則稱為`里氏替換原則`(The Liskov Substitution Principle. LSP)，當然 LSP 並非僅限於 Template Pattern

> LSP(The Liskov Substitution Principle)
>
> Subtypes must be substitutable for their base types.

## 延伸閱讀

### 子類責任(subclass responsibility)

在我們理解父類子類關係時，通常會站在子類角度進行思考，也就是容易著重於：

- **在子類中可以使用父類中定義的方法**
- **可以通過子類中增加方法來實現新功能**
- **在子類中重寫父類方法可以改變程式的行為**

現在我們改變一下立場，父類定義了些抽象方法是希望

- **期待子類去實現抽象方法**
- **要求子類去實現抽象方法**

也就是說，子類有去實現這些父類所定義的抽象方法的責任，該責任被稱為**子類責任(subclass responsibility)**

### 抽象的意義

在抽象類中所定義的抽象方法並沒有據的實現，所以我們無法得知這些抽象類方法的處理邏輯，但可以決定抽象方法的名字，隨然實作上邏輯還是由子類決定，但**在抽象類階段決定處理流程非常重要**

### 父類與子類的協作

太多方法在父類實現會讓子類更輕鬆，不過也降低了子類的靈活性，相反的，如果父類方法過少，子類就會變得相當擁腫，可能還會導致產生重複的程式碼

在 Template Pattern 中，處理**流程**被定義在父類中，具體**處理**則交給子類，至於哪些該放在父類，哪些該放在子類，就需要由工程師們自行決定了

## 結語

> 文中的 Source Code 都放在 [github](https://github.com/VagrantPi/golang-design-pattern/tree/master/3.template) 了，自己 clone 下來玩玩吧

前幾天 ACE COMBAT 7 終於發售了，還記得 15 年看著 E3 消息說要出續作，到了 19 年終於讓我等到了，我玩的遊戲都好冷門啊 QQ

這篇多了不少專有名詞的東西，golang 的實作上也花了我比較多時間(((ﾟДﾟ;)))

最近生活就差不多是被 deadline 追著跑(希望過年別被 on call)、還還技術債、玩 ACE COMBAT 7、想到就翻一下 design pattern、~~如果還有空就刷點 LeetCode~~

好想多點時間打 Game 呀！～

## 系列文章

- [Design Pattern 筆記 - Iterator Pattern]({{ site.url }}/2019/01/01/design-pattern-iterator/)
- [Design Pattern 筆記 - Adapter Pattern]({{ site.url }}/2019/01/07/design-pattern-adapter/)
- [Design Pattern 筆記 - Template Pattern]({{ site.url }}/2019/01/28/design-pattern-template/)
- [Design Pattern 筆記 - Singleton Pattern]({{ site.url }}/2019/03/03/design-pattern-singleton/)



