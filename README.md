# VagrantPi's Blog

紀錄一些生活札記

Blog 使用 [hyde](https://github.com/poole/hyde) 建置

Website: https://vagrantpi.github.io/

## install dependency

```
gem install bundler
bundle install
```

## build

```
$ sh build.sh
```

## serve in local

```
$ jekyll serve -H 0.0.0.0
Auto-regeneration: enabled for '/VagrantPi.github.io'
   Server address: http://0.0.0.0:4000/
 Server running... press ctrl-c to stop.
```

## build 時可能遇到的問題

```
You have already activated public_suffix 5.0.1, but your Gemfile requires public_suffix 5.0.0. Prepending `bundle exec` to your command may solve this.

可以使用
bundle clean --force
```

## 使用 docker 環境

### 開發 

```
docker run --rm \
  -v "$PWD:/srv/jekyll:Z" \
  -p 4000:4000 \
  jekyll/jekyll \
  jekyll serve
```

### 編譯

<!-- 
記錄一下，container 內印出的版本
ruby 3.1.1p18 (2022-02-18 revision 53f5fc4236) [x86_64-linux-musl]
jekyll 4.3.2
-->

```
docker run --rm \
  -v "$PWD:/srv/jekyll:Z" \
  jekyll/jekyll \
  jekyll build
```