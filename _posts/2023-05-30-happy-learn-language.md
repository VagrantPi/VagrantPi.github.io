---
layout: post
title: "開開心心學 Ruby 活動筆記"
subtitle: 開開心心學 Ruby 活動筆記
description: "開開心心學 Ruby 活動筆記"
author: VagrantPi
tags: EventNote Ruby
imgurl-fb: /public/img/index/ruby.jpg
imgurl: /public/img/index/ruby.jpg
image: /public/img/index/ruby.jpg
imgalt: ruby 
---

## Intro

常常會滑 Accupass 有什麼新的 workshop，剛好看到了 [開開心心學 Ruby](https://www.accupass.com/event/2305080608171274778481)，所以帶著正在轉職路上的女友一起報名了，本來只是想要體會一下不同語言間有什麼特性差異，但意外地學習到很多，這邊簡單紀錄一下今天活動的收穫

## 本日重點

- 多想，為什麼？

從學校一路學上來，不管是跟著教科書，還是跟著教授，只會跟你說

這邊這樣寫，會得到這樣的結果

但往往沒有思考過，那為什麼這邊要寫這樣呢?

整天的課程幾乎都圍繞著

丟出疑問 => 同學們提出想法 => 講師的解答 => 恍然大悟或是感到一些 shock

的迴圈當中，很多現在熟悉的寫法或是用法，其實背後都是有原因的

我覺得相當的有趣

## nil?

```ruby
nil.nil?
# true
```

所以 nil 還存在嗎？其實從這就可以看出 ruby 語言其實不像程式語言，更像是英文

那當 nil 回傳 存在(true)。那這本身就很抽象

一個代表不存在，且存在的實體物件

另外再 Javascript 中也有類似的東西

```
NaN => "not a number"
```

但是

```javascript
typeof NaN

'number'
```

Why?

> 1/'a'
> 因為還是為數字，但計算後不是數字
> 所以回傳一個 number 物件，來告訴你這部是數字

## 變數

為何會需要變數？

眾人答案:

- 方便未來做替換
- 對於某個數值賦予意義

而講師的回答是

> 在眾多人中要怎麼指出某個人？你的姓名

## 常數

在 ruby 中第一個字大寫，的變數就是常數

但是可以複寫，只會跳出 Warning

換成看各位比較熟悉的 Javascript

```javascript
const list = [1, 2, 3, 4]
list[0] = 'x'

list
// ['x', 2, 3, 4]


// 那重新塞值呢
list = [1, 2, 3, 4]
// 1476:1 Uncaught TypeError: Assignment to constant variable.
// at <anonymous>:1:6
```

So Why?

其實回到上面的宣告可以看出端倪

```javascript
const list = [1, 2, 3, 4]
```

這邊解讀起來是什麼?

宣告，記憶體位置，assign 資料

OK，也許你有猜到了

對於某些來說 const 的設計其實代表的是不能 re-assign 的變數

## 函數/方法

可能會聽到以下兩種

- function 函數
- method 方法

差異是什麼？

如何『解釋』『說出』?

> 這邊沒有記錄到當時的討論，然後講師繼續往下解釋 function

以數學來說

```
f(x) = 3x + 2
```

轉換簡單轉成程式碼

```
function aaa(x) {
    return 3 * x + 2
}
```

而這邊講師對於 function 的定義做了一些解釋
> 定義輸入值與輸出值的關係

```
f(x) = 3x + 2
2 --> 8
3 --> 11
4 --> 14
```

但是 function 隨著一些業務邏輯或是其他操作往往會出現 side effect

- 如在 function 中呼叫資料庫
- 呼叫第三方服務

那其實就有點違反了 function 本身的定義

所以好的 func 不會有 side effect
> 但理想上不存在，因此盡量放在最後做（分層）
> 另外也因此誕生了一個新的流派，Functional programming

### function 的寫法

```ruby
def print(msg = 'hi')
  puts msg
end

print('hello world')
```

另外提一下，ruby 是可以選擇省略括號的

```reuby
print hello world
```

又可以再看得出來值，這樣閱讀起來會更像英文

### 另外提到的特性

```ruby
age = 20
def age
  return 18
end

# 前面有提到，可以不用括號
# 但這邊有兩個 age
puts age
# 20
```

我們可以簡單通過錯誤訊息來檢驗這個問題

```ruby
age = 20
def age
  return 18
end

puts agesss # 改一下奇怪的不存在變數
```

```
main.rb:18:in `<main>': undefined local variable or method `agesss' for main:Object (NameError)

puts agesss
     ^^^^^^
```

我們可以從錯誤訊息可以看出，先找 `variable` 再找 `method`

```ruby
puts age
```

所以按照上面的規則

`age variable` -> `age method`

所以會是印出 `20`

那如果要讓他印出 `18` 呢?

```ruby
puts age()  # 把括號補回來
```

## 如果 function 回傳值為 boolean

ruby 慣例會寫上 `?`

```ruby
def is_audit?()
```

```ruby
[].empty?
> true

[1, 2, 3].empty?
> false
```

也許看起來很怪？

不過如果用英文來看 empty? ，這是個問句，只會回傳對或錯

但你在寫 xxxx? 後，一樣可以回傳其他型別，所以只能說是慣例上

簡單來說 empty 在這邊是動詞還是名詞？而在 ruby 的設計來看就是讓它可以識別

```ruby
def adult?(age)
    age >= 18
end
```

### 需要看手冊，可能發生意外的驚喜

加上 `!`

```ruby
def go!()
```


```ruby
list = [2, 3, 1, 5]

list.sort

p list
```

會印出

```
[2, 3, 1, 5]
```

你可能會預期是印出有排序的東西

但實際上，只呼叫 func 不應該修改到原本的內容

這樣其實是合理的，因為可能在某個地方呼叫到，而 list 就會被修改

```ruby
list = [2, 3, 1, 5]

list.sort! # in place

p list
```

而通常會有 `!` 都會有一個正常版本

所以通常代表一個動作，或是需要看手冊

### Falsy Values

對 ruby 來說只有 
- `false`
- `null`

代表 Falsy Values

反過來看 Javascript
- `false`
- `0`
- `null`
- `undefined`

就設計來說，Javascript 的設定來說有點多

在一些程式語言設計中

`const list = [1, 2, 3, 4]`

宣告，記憶體位置，assign 資料


## block

- `{ ... }`
- `do ... end`

## 遍歷 array

```ruby
list = [1, 2, 3, 4, 5]
for item in list
  p item
end

# 比較常見寫法
list.each{ |x|
  p x
}
```

看看 JS

```javascript
list.forEach((x) => {
    console.log(x)
})
```

可以類比成

```javascript
list.forEach(|x| => {
    console.log(x)
})
```

### 其他方法

```ruby
doubleList = list.map do |item|
    return 2 * item
end

p doubleList 
# 這邊不會印出東西
# 因為在 do ... end 中，return 中，會直接整個程式碼 return


doubleList = list.map do |item|
    2 * item
end

p doubleList 
```

```ruby
# each 5 -> x (不會回傳)
# map 5 -> 5(會回傳相等的 item)
# filter 5 -> (<=5)
# reduce 5 -> single value
```

## 命名

double_list - 蛇式

## Symbol

```ruby
# hero = {:name=>"kk", :age=>18} 
hero = {name: 'kk', age: 18} # > ruby 1.9 寫法

# :xxx <-- Symbol

p hero
# {:name=>"kk", :age=>18}   所以上面寫法本質上還是舊的方式

p hero[:name]  # 因此取值時需要使用 :
# 'kk'
```

### 如果有很多層

```ruby
p hero[:name][:a][:b]
```

如果裡面的內容有異動，那就會爆炸

```ruby
# 往下挖，如果挖得到
p hero.dig(:name, :a, :b)
```

## OOP

### class（具象類別）是什麼

可以簡單想成`生物分類法`

### 沒有 override 而是一層一層往上找

```ruby
class Animal
  def eat
    p "yummy!"
  end
end

class Cat < Animal
  def eat
    p "123!"
  end
end

kitty = Cat.new
kitty.eat
# "123!"
```

### 模組化

假設有奇怪需求，`一隻飛天貓`

```ruby
class Animal
  def eat
    p "yummy!"
  end
end

module Flyable
  def fly
    p "fly!"
  end
end

class Cat < Animal
  include Flyable
  
  def eat
    p "123!"
  end
end

class Dog < Animal
end


kitty = Cat.new
kitty.fly
# "fly!"
```

並不會複製進來，而是往上找時，先找模組找找看

### 繼承與模組的關係

```ruby
p Cat.ancestors # 所有祖先
# [Cat, Flyable, Animal, Object, Kernel, BasicObject

p Cat.superclass.superclass.superclass # 該 class 的上一層
# BasicObject
```

因此可得知 Kernel，也是 module


### singleton method

只有該類別存在的方法

下面註解都是等價的

```ruby
class Cat < Animal
    def self.fly
    # def Cat.fly
        p "fly!!!"
    end
end


# def def Cat.fly ...
kitty = Cat.new
kitty.fly
```

### 開放類別

```ruby
class Cat   
  def eat
    p "123!"
  end
end

class Cat   
  def run
    p "456!"
  end
end

kitty = Cat.new
kitty.eat
kitty.run
```

這邊算是 ruby 的特性，如果存在相同 Class 宣告

通常會想到的可能性

- 直接報 Error
- 後面的複寫上面的

但在 ruby 中他允許重複，且會融合內部的 function

> 如果兩個都有一樣的 function ，才會後面複寫前面

那也因為這個特性，所以可以為原始類別加上方法

```ruby
class String
    def valid_email?
        true
    end
end

p "kk@gmail.com".valid_email?
```

### 而在 Rails 時中又有更多這類型的 function

在 Rails 中就可以看到

針對取 array 這件事，時做了一堆而外的 function

```ruby
# 取第一個 item
p [ "q", "r", "s", "t" ][0]
# q

# 而在 Rails 中有人實作了
p [ "q", "r", "s", "t" ].first
# q
```

那他一路做到了 fifth

那就有人偷嘴說，這麼無聊那你怎麼不做個 42

於是就出現了這個

https://apidock.com/rails/Array/forty_two

`[1,2,3,4].forty_two`

## 這個特性很有趣

舉裡: 我現在要取前一天的

回到我熟悉的語言 Golang 中

```go
time.Now().Add(-24 * time.Hour)
```

那回到 ruby 中可以加上 function 後達到

```ruby
Time.now.ago(24.hours)
```

因該可以看的出來哪個更像英文吧?


## 回到對於常數的思考

如果常數能夠改變，那為何還需要常數?

```ruby
class cat
end
```

```
main.rb:7: class/module name must be CONSTANT
class cat
exit status 1
```

看得出來嗎？class 命名是常數，還記得前面提到大寫自首為常數

也因為常數可以被修改，才造就了 `開放類別` 這個類性

但為了這個『方便的』`開放類別`，而讓常數可以被修改

這樣算是個好設計嗎？

## 結語

以下是我的心得:

可以看出講師想要帶給我們的不是，教你這個東西就「這樣」寫就好了

而是程式語言被「設計」，一定有一個明確的原因目的，或是時空背景

也可以藉此反思，那如果是你來設計，你又會怎麼設計?

前同事有一句話一值留在我腦裡

「軟體工程師的價值，在於抽象化的能力」

而今天走完整個 Workshop 後，我的體悟是

程式語言本身就是個設計，那這些設計的哲學是否能幫助你未來開發上，幫上忙呢?

所以要多思考為什麼? 而不是只是簡單填充程式碼的碼農

