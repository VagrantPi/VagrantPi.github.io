---
layout: post
title: go-ethereum Signature
subtitle: go-ethereum Signature
description: go-ethereum Signature
author: VagrantPi
tags: Golang Blockchain
imgurl-fb: /public/img/index/gopher-fb.jpg
imgurl: /public/img/index/gopher.jpg
imgalt: gopher logo
---

## 前言

很久沒寫東東了，平常除了打 PS4 外就是在耍廢，浮上來刷個存在感好了

當完兵後進了間區塊鏈公司寫後端打打雜，對於 blockchan 來說我完全是麻瓜，然後為了找一個很 87 的問題，搞了個下午，最後還是被同事找到的，所以還是來筆記一下關於 Ethereum 中的簽名(Signature)好了

## 免責申明

麻瓜寫的文章可想而知，如果任何錯誤還請先進們多多指點

## 所以說 Signature 是做啥的

在使用加密貨幣前都需要建立一個 wallet，wallet 建立時會包含著公私鑰和錢包位置

當你要做交易時，為了防止交易被串改，當你要發出資訊時，需要對要這些訊息使用私鑰做簽名，上鏈過後任何人都可以透過公鑰來驗證這筆交易是不是這個錢包位置所發出的，如果正確，那就可以確定該筆交易沒被串改過

而以太坊採用的簽名技術為 [橢圓曲線加密](https://medium.com/@VitalikButerin/exploring-elliptic-curve-pairings-c73c1864e627)(別問我，我看不懂 (つд⊂))，所以你簽完名後會拿到 v、r、s 三個變數，下面就使用 go-ethereum 示範一下

## 上 code

簽名：

```go
// Create an account 
key, err := crypto.GenerateKey()
// Get the address
address := crypto.PubkeyToAddress(key.PublicKey).Hex()
// hash message
msgHash := crypto.Keccak256([]byte("hello world!"))
// signature msgHash
sig, err := crypto.Sign(msgHash, key)
if err != nil {
    t.Errorf("Sign error: %s", err)
}
Lgentry.Infof("f=%x\n", sig)
r := fmt.Sprintf("%x", sig[:32])
s := fmt.Sprintf("%x", sig[32:64])
v := int(sig[64]) + 27
msgHashStr := fmt.Sprintf("%x", msgHash)
```

![](/public/img/post/cryptography/1.jpg)

驗簽：

VerifySignature try 了很久，不知道怎麼用，後來找到了這篇 [Geth ecrecover invalid signature recovery id](https://stackoverflow.com/questions/49085737/geth-ecrecover-invalid-signature-recovery-id)

```go
// SignatureIdentify verify the signature with public key
func SignatureIdentify(sigR, sigS, uAddr string, sigV int, rmsgh string) bool {
  Lgentry.Info("signature verification")

  // sigPass := true
  // parse signature v to heximal string
  SignatureV := fmt.Sprintf("%x", sigV)
  // now r,s,v are all heximal string, concatenate them
  signatureConc := "0x" + sigR + sigS + SignatureV
  // use hexutil.MustDecode parse it to []byte
  signatureBuf := hexutil.MustDecode(signatureConc)

  Lgentry.Debugf("signature length: %d", len(signatureBuf))
  if signatureBuf[sigEnd] != vis27 && signatureBuf[sigEnd] != vis28 {
    Lgentry.Warn("Signature end is not 27/28")
    return false
  } else {
    Lgentry.Debug("sig end PASS")
  }
  Lgentry.Debugf("SIGHEX string is: %x", signatureBuf)
  Lgentry.Debugf("SIGHEX length is: %d", len(signatureBuf))
  signatureBuf[sigEnd] -= vis27

  hmsg, _ := hex.DecodeString(rmsgh)

  pubKey, err := crypto.SigToPub(hmsg, signatureBuf)
  if err != nil {
    Lgentry.Errorf("signature to public key Error: %s", err.Error())
    return false
  } else {
    Lgentry.Debug("sig to pub PASS")
  }

  recoverAddr := crypto.PubkeyToAddress(*pubKey)
  if recoverAddr != common.HexToAddress(uAddr) {
    Lgentry.Warn("Address is not match w/ signature")
    return false
  } else {
    Lgentry.Debug("Address MATCH")
  }

  Lgentry.Info("signature verification DONE")
  return true
}
```

![](/public/img/post/cryptography/2.jpg)

## 結語

結果也是 copy paste 過來而已 d(`･∀･)b，不過上班以來也累積不少筆記了，拿天心血來潮再移到這邊好了

先不說這個了夏日課程到貨了，該躲進 VR 世界耍廢了~


