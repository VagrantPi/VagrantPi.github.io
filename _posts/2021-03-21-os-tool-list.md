---
layout: post
title: "開發環境預裝工具"
subtitle: 開發環境預裝工具
description: "開發環境預裝工具"
author: VagrantPi
tags: Other
imgurl-fb: /public/apple-touch-icon-144-precomposed.png
imgurl: /public/apple-touch-icon-144-precomposed.png
image: /public/apple-touch-icon-144-precomposed.png
imgalt: VagrantPi 
---

## 前言

最近將筆電灌成了 Ubuntu，突然熟悉的指令或是工具都需要重新安裝，然後各類設定檔散落於各處，或是有些裝過已經忘記叫什麼了，所以乾脆就寫個清單紀錄一下常用工具的清單與安裝流程，方便未來複製貼上

不定期更新 \_(:3 」∠ )\_

## terminal 相關

### powerline

提供 vim, bash 顯示各類狀態的工具

> Vim statusline
> ![](https://camo.githubusercontent.com/853e176b09fed9071a6e9c61040ecb96d900d087dd780dd6fb3704e51dd32ca6/68747470733a2f2f7261772e6769746875622e636f6d2f706f7765726c696e652f706f7765726c696e652f646576656c6f702f646f63732f736f757263652f5f7374617469632f696d672f706c2d6d6f64652d6e6f726d616c2e706e67)

```shell
sudo apt-get install powerline
font_dir="$HOME/.local/share/fonts"
mkdir -p $font_dir
wget https://github.com/powerline/fonts/raw/master/Hack/Hack-Regular.ttf -P $font_dir
fc-cache -f "$font_dir"
echo -e "POWERLINE_SCRIPT=/usr/share/powerline/bindings/bash/powerline.sh\nif [ -f $POWERLINE_SCRIPT ]; then\n  source $POWERLINE_SCRIPT\nfi" >> ~/.bashrc
```

### .vimrc & Vundle

vim 套件安裝，之前有一陣子使用 vim 寫 code，有些快捷鍵使用蠻順手，可以選擇性裝一下（有些安裝起來很麻煩，比如 YouCompleteMe

```
" 快捷鍵     |    套件
" -----------|------------
"  <F2>      | NERDTree
"  <F3>      | undotree
"  <F4>      | Tagbar 
"  <F5>      | buffers switch
"  <F6>      | indentLine
"  <F7>      | eslite
"  <F9>/<F10>| 切換 color scheme
"  \t        | command-t
"  \c<space> | 註解
"
```

```shell
# download .vimrc
wget https://raw.githubusercontent.com/VagrantPi/Vim/master/.vimrc -P ~

# Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# vim-pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# compile YouCompleteMe
sudo apt install python3-dev
sudo apt-get install cmake3
sudo apt-get install g++
sudo apt-get install default-jre default-jdk
# set java env
echo "JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> ~/.bashrc
cd ~/.vim/bundle/YouCompleteMe
python3 install.py --all
```

## 程式語言

### nodejs

> download: https://nodejs.org/en/download/

```shell
wget https://nodejs.org/dist/v14.16.0/node-v14.16.0-linux-x64.tar.xz
# Nodejs
VERSION=v14.16.0
DISTRO=linux-x64
export PATH=/usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin:$PATH
source ~/.bashrc
```

### golang

> download: https://golang.org/dl/

```shell
get https://golang.org/dl/go1.16.2.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.2.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
```

## 各類 service & 其他

### sshd

```
sudo apt-get install -y openssh-server
```

### docker

```shell
sudo apt-get update
sudo apt-get install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

### mount disk from windows(ntfs)

原先系統是 win10，在重灌成 ubuntu 後需要重新掛載原本的 D 槽

修改 `fstab` 重起電腦就會自動掛載了

```shell
sudo mkdir /media/D 

# 查看磁碟分割區 UUID
sudo blkid
sudo vim /etc/fstab
UUID="45f6c60b-c10e-4761-a4be-d3ee4cc2d1bf" /media/D      ntfs    uid=1000,gid=1000,umask=077,fmask=177 0 0

sudo mount /media/D 
```

### SWAP


如果當初沒切 SWAP，或是常常 aws ec2 開起來後發現沒有 swap 時可以新增一下

```shell
# add swap
sudo swapon -s
free -m
df -h
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
free -m
sudo vim /etc/fstab
最後加這行即可開機自動掛載
/swapfile   none swap    sw 0 0

# delete swap
sudo swapoff /swapfile
```

## 常用軟體

### Typora

Markdown 編輯器

```shell
# or run:
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE
wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
# add Typora's repository
sudo add-apt-repository 'deb https://typora.io/linux ./'
sudo apt-get update
# install typora
sudo apt-get install typora
```

To Be Continued...