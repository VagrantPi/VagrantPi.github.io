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
