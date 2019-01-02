---
layout: post
title: "Design Pattern - Iterator Pattern 筆記"
subtitle: 圖解設計模式讀書筆記 - Iterator Pattern
description: "Iterator Pattern 筆記"
author: VagrantPi
tags: Design_Pattern Note
imgurl: /public/img/index/gopher.jpg
imgalt: gopher 
---

## 前言

前陣子在天瓏買了本『圖解設計模式』，家中的書越積越多了，新年新希望，來個系列文章把這本書涵蓋的 Pattern 給填完好了 (つд⊂)

> 本文使用的參考書籍範例使用 Java，而筆者則是使用 Golang 實作，因此描述跟實作上可能會有些出入

## Iterator Pattern

常見的遍歷多以 for 迴圈來實作

```go
arr := []string{"1", "2", "3"}

for _, item := range arr {
  fmt.Println(item)
}

for i := 0; i < len(arr); i++ {
  fmt.Println(arr[i])
}
```

以下面的 for 範例來說，i 會不斷 ++ 循環來遍歷 arr 陣列中的元素，將 i 的功能抽象化後、通用化後就變成了 Iterator Pattern 了

此範例實作一個書架，並將書放到書架上，然後遍歷整個架上的書本，下面範例會直接貼上書上的 java 範例程式和我寫的 golang 程式碼

## Class Diagram

![Iterator Pattern](/public/img/post/design_pattern/iteractor_pattern.png)

name | descreption
-----|------------
Aggregate | 該 pattern 所用到的 Interface 集合
Iterator | 遍歷的 interface
Book | 書的 class
BookShelf | 書架的 class
BookShelfIterator | 遍歷書架的 class

## 範例

### Interface

#### Aggregate

Iterator Pattern 功能的集合(只有 Interator 的 Interface)

java:

```java
public interface Aggregate {
  public abstract Iterator iterator();
}
```

go:

```go
type Aggregate interface {
  Iterator() Iterator
  // 這邊會多個 Append 為了方便 Aggregate 的 instance(bookShelf) 可以直接使用 Append 這個 Method
  Append(interface{})
}
```

#### Interator

該 Interator(遍歷器)最主要有兩個 method：

1. HasNext()：是否有下一個 item()
  回傳 true/false 用以決定是否停止遍歷
2. Next()：回傳當下的 Book 並指向下一個 Book

java:

```java
public interface Iterator {
  public abstract boolean hasNext();
  public abstract Object next();
}
```

go:

```go
type Iterator interface {
  HasNext() bool
  Next() interface{}
}
```


### Implement

#### Book class

作為該範例中最基本的單位，不過在 Golang 的世界中沒有 Class，所以這邊我把它當作是 struct

java:

```java
public class Book {
  private String name;
  public Book(String name) {
  this.name = name;
  }
  public String getName() {
  return name;
  }
}
```

go:

```go
package book

type BookI interface {
  SetName(n string)
  GetName() string
}

type Book struct {
  name string
}

func (b *Book) SetName(n string) {
  b.name = n
}

func (b Book) GetName() string {
  return b.name
}
```

#### BookShelf class

書架，紀錄書架內的書本資訊

java:

```java
public class BookShelf implements Aggregate {
  private Book[] books;
  private int last = 0;
  public BookShelf(int maxsize) {
  this.books = new Book[maxsize];
  }
  public Book getBookAt(int index) {
  return books[index];
  }
  public void appendBook(Book book) {
  this.books[last] = book;
  last++;
  }
  public int getLength() {
  return last;
  }
  public Iterator iterator() {
  return new BookShelfIterator(this);
  }
}
```

go:

```go
package model

import (
  "design_pattern/1.iterator/book"
)

type Aggregate interface {
  Interator() Interator
}

type BookShelf struct {
  books []book.Book
  last  int
}

func (b *BookShelf) BookShelf(maxsize int) {
  b.books = make([]book.Book, maxsize)
}

func (b *BookShelf) GetBookAt(index int) book.Book {
  return b.books[index]
}

func (b *BookShelf) Append(abook interface{}) {
  if b.GetLen() >= len(b.books) {
    newBooks := make([]book.Book, b.last*2)
    for index, item := range b.books {
      newBooks[index] = item
    }
    b.books = newBooks
  }
  b.books[b.last] = abook.(book.Book)
  b.last++
}

func (b *BookShelf) GetLen() int {
  return b.last
}

func (b *BookShelf) Iterator() Iterator {
  i := &BookShelfIterator{}
  i.BookShelfIterator(b)
  return i
}

```

#### BookShelfIterator

書架遍歷器的 Instance

java:

```java
public class BookShelfIterator implements Iterator {
  private BookShelf bookShelf;
  private int index;
  public BookShelfIterator(BookShelf bookshelf) {
  this.bookShelf = bookShelf;
  this.index = 0;
  }
  public boolean hasNext() {
  if(index < bookShelf.getLength()) {
  return true;
  } else {
  return false;
  }
  }
  public Object next() {
  Book book = bookShelf.getBookAt(index);
  index++;
  return book;
  }
}
```

go:

```go
package model

type Iterator interface {
  HasNext() bool
  Next() interface{}
}

type BookShelfIterator struct {
  bookShelf BookShelf
  index     int
}

func (b *BookShelfIterator) BookShelfIterator(bookShelf *BookShelf) BookShelfIterator {
  b.bookShelf = *bookShelf
  b.index = 0
  return *b
}

func (b *BookShelfIterator) HasNext() bool {
  if b.index < b.bookShelf.GetLen() {
    return true
  }
  return false
}

func (b *BookShelfIterator) Next() interface{} {
  book := b.bookShelf.GetBookAt(b.index)
  b.index++
  return book
}
```

### Main

java:

```java
public class Main {
  public static void main(String[] args) {
  BookShelf bookShelf = new BookShelf(4);
  bookShelf.appendBook(new Book("Around the World in 80 Days"))
  bookShelf.appendBook(new Book("Bible"))
  bookShelf.appendBook(new Book("Cinderella"))
  bookShelf.appendBook(new Book("Daddy-Long-Legs"))
  Iterator it = bookShelf.iterator();
  while (it.hasNext()) {
  Book book = (Book)it.next();
  System.out.println(book.getName());
  }
  }
}
```

go:

```go
package main

import (
  "fmt"

  "design_pattern/1.iterator/book"
  "design_pattern/1.iterator/model"
)

func main() {
  var bookShelf model.Aggregate
  b := &model.BookShelf{}
  b.BookShelf(3)
  bookShelf = b
  aBook := &book.Book{}
  aBook.SetName("Around the World in 80 Days")
  bookShelf.Append(*aBook)
  bBook := &book.Book{}
  bBook.SetName("Bible")
  bookShelf.Append(*bBook)
  cBook := &book.Book{}
  cBook.SetName("Cinderella")
  bookShelf.Append(*cBook)
  dBook := &book.Book{}
  dBook.SetName("Daddy-Long-Legs")
  bookShelf.Append(*dBook)
  it := bookShelf.Iterator()
  for it.HasNext() {
    book := it.Next().(book.Book)
    fmt.Println(book.GetName())
  }
}
```


## So Why?

> 不管 Instance 如何變化，都可以使用 Iterator

```go
it := bookShelf.Interator()
for it.HasNext() {
  book := it.Next().(book.Book)
  fmt.Println(book.GetName())
}
```

while 的迴圈不依賴於 bookShelf 的 Instance，所以如果 bookShelf 的 books 不用 array 存了，或是 BookShelf, Book, BookShelfIterator 改成其他的資料型態的 Instance(EX: Warehouse, Box, WarehouseIterator)，也不會影響到原本 `for it.HasNext()` 內的邏輯

### 範例 2

bookShelf 的 Books 改用 String 存了

```go
type BookShelf struct {
  books string
  last  int
}

func (b *BookShelf) BookShelf(maxsize int) {
  // b.books = make([]book.Book, maxsize)
}

func (b *BookShelf) GetBookAt(index int) book.Book {
  s := strings.Split(b.books, ",")
  aBook := book.Book{}
  aBook.SetName(s[index])
  return aBook
}

func (b *BookShelf) Append(abook interface{}) {
  if len(b.books) == 0 {
    b.books = abook.(book.Book).GetName()
  } else {
    b.books = b.books + "," + abook.(book.Book).GetName()
  }
}

func (b *BookShelf) GetLen() int {
  s := strings.Split(b.books, ",")
  return len(s)
}

func (b *BookShelf) Iterator() Iterator {
  i := &BookShelfIterator{}
  i.BookShelfIterator(b)
  return i
}
```

這邊直接改掉 BookShelf 格式和相關 Instance 就好，舊有的 code 都不需要改

## 結語

> 文中的 [Source Code](https://github.com/VagrantPi/golang-design-pattern/tree/master/1.iterator) 都放在 github 了

小弟新手 gopher，這也是第一次看 design pattern 所以如果有任何錯誤還請幫忙指正

目標是兩個禮拜發一篇啦，這邊累積的文章太少了，不過拖更什麼的也是很正常的 \_(:3 ⌒ﾞ)\_