---
layout: post
title: "Solidity 中的 Mapping"
subtitle: "Solidity Mapping 使用教程 - Mapping  vs  array"
description: "Solidity 中 Mapping  vs  array 的差異、使用教程，如何在智能合約中使用 Mapping"
author: VagrantPi
tags: Ethereum Blockchain
imgurl-fb: /public/img/index/ethrttock.jpg
imgurl: /public/img/index/smart-contract.png
image: /public/img/index/smart-contract.png
imgalt: smart-contract
---

## Intro

最近在整理 Hackmd 上的筆記，把一些東東拿出來寫

在實作某個需求時，需要

- 用戶只能鑄造一張 NFT

- 用戶質押時，NFT 會進到一個池子

- 需要有方法亂數取池子內其中一個 NFT

- 用戶解質押時，NFT 會移出池子

一開始想到使用 `array` 來存池子內有哪些 NFT id，然後通過 array len 來 random 出一個 index 來取出 NFT

但是移除時，要從 `array` 找到找到 index 並刪除，最差情況下要找完整個 `array`

又想想做 set, delete 的需求，Mapping 很合適

但是 Mapping 無法知道長度有多長，無法使用上面想到的 random index 的方式取出其中一個值

那先來看看 Solidity 中，Mapping 是怎麼運作的

## Solidity 中的 Mapping

Mapping 在使用上類似於 HashTable 的結構，建立時初始化所有可能的 key

當要對 key 儲存 value 時，會透過 keccak256 的方式來來計算出存放位置（[storage slot](https://ctf-wiki.org/blockchain/ethereum/storage/#_3)）

```
a[addr] = 1

Ethereum Storage
-----------------------------|-----------------
....                         |
keccak256(addr, slot)        | 1
....                         |
```

文件也寫明 Mapping 只是一種 `storage-only key-value data structure`，所以你設了多少 key，Mapping 並沒有方法可以知道

另外，所以如果 Mapping 的 `ValueType` 為 `動態 Array` 情況下，在呼叫 delete 後，這些可能造成資料殘留的狀況

> 以下範例節錄自 [Solidity Document - Clearing Mappings](https://docs.soliditylang.org/en/v0.8.17/security-considerations.html#clearing-Mappings)

```javascript
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.9.0;

contract Map {
    Mapping (uint => uint)[] array;

    function allocate(uint newMaps) public {
        for (uint i = 0; i < newMaps; i++)
            array.push();
    }

    function writeMap(uint map, uint key, uint value) public {
        array[map][key] = value;
    }

    function readMap(uint map, uint key) public view returns (uint) {
        return array[map][key];
    }

    function eraseMaps() public {
        delete array;
    }
}
```

這邊呼叫

- `allocate(10)`

- `writeMap(4, 128, 256)`

- `eraseMaps`

此時 array 的長度會歸零，但資料任然在 `storage slot` 上，所以接著呼叫

- `allocate(5)`

- `readMap(4, 128)`

此時會拿到 256 這個數值

因此這邊也提到，如果要安全地使用 Mapping 可以追蹤所有 keys 並且適當的刪除，這邊也提供了解法

就是實作 Iterable 的方法，可以遍歷整個 Mapping

可以配合需求，來刪除對應的 key

## Solidity 中的 Map 遍歷

> [Solidity Document - Iterable Mappings](https://docs.soliditylang.org/en/v0.8.17/types.html?highlight=Mapping#iterable-Mappings)

這邊簡單的註解說明

```javascript
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.8;

// 實際
struct IndexValue {
    // array 中的 index
    uint keyIndex;
    // 實際的 value
    uint value;
}
struct KeyFlag {
    // 實際的 key
    uint key;
    // 是否 delete 掉了
    bool deleted;
}

struct itmap {
    Mapping(uint => IndexValue) data;
    KeyFlag[] keys;
    uint size;
}

type Iterator is uint;

library IterableMapping {
    function insert(itmap storage self, uint key, uint value) internal returns (bool replaced) {
        uint keyIndex = self.data[key].keyIndex;
        self.data[key].value = value;
        // 檢查這個 key 是否存在於 keys array 中
        if (keyIndex > 0)
            return true;
        else {
            // 第一次 insert 則將 key 的資料 push 進 keys array
            keyIndex = self.keys.length;
            self.keys.push();
            self.data[key].keyIndex = keyIndex + 1;
            self.keys[keyIndex].key = key;
            self.size++;
            return false;
        }
    }

    function remove(itmap storage self, uint key) internal returns (bool success) {
        // 取出這個 key 在 keys 中的 index
        uint keyIndex = self.data[key].keyIndex;
        if (keyIndex == 0)
            return false;
        delete self.data[key];
        // 把這個 key 標記成 deleted
        self.keys[keyIndex - 1].deleted = true;
        self.size --;
    }

    ...
}
```

## 回到需求

這邊我們採用差不多的概念，來處理我們的需求

- 實際資料存放在 array 中

- 使用 Mapping 來紀錄 set 時，在 array 中的 index，用來 delete 時判斷

  - 如果是最後一個 array.pop 就好

  - 如果是刪除中間的數值，則取最後一個值替換，然後 index 值更新

```javascript
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


contract NFTPool {

    uint256[] public datas; // NFT列表
    Mapping(uint256 => uint256) public dataIndex; // NFT 列表 array idx

    function push(uint256 tokenId) public {
        datas.push(tokenId);
        dataIndex[tokenId] = datas.length;
    }

    function remove(uint256 tokenId) public {
        uint257 total = datas.length;
        uint256 idx = dataIndex[tokenId]; // 獲取 NFT array id

        // 不存在則跳過
        if (idx == 0) {
            return;
        }

        // 如果刪除 array 中間
        if (total != (idx)) {
            // 把最後item移到刪除的idx位置
            datas[idx - 1] = datas[total - 1];
            dataIndex[datas[total - 1]] = idx;
        }

        // 刪除array最後一個
        datas.pop();
        delete dataIndex[tokenId];
    }


    function find() public view returns(uint256){
        uint256 rand = _random();
        uint256 idx = rand % datas.length;
        return datas[idx];
    }

}
```

## 結語

初出茅廬的 Solidity 開發，很多東西還不是很熟悉

然後又得面對各類業主的奇葩需求

感覺很多東西學得不夠扎實，整理筆記順便重新學習一些知識也不錯

> 參考:
>
> - [Solidity Tutorial: all about Mappings](https://medium.com/coinmonks/solidity-tutorial-all-about-Mappings-29a12269ee14)
>
> - [Ethereum Storage - 映射](https://ctf-wiki.org/blockchain/ethereum/storage/#_3)
>
> - [Solidity Document - Mapping Types](https://docs.soliditylang.org/en/v0.8.17/types.html?highlight=Mapping#Mapping-types)
