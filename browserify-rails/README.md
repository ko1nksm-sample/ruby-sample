# browserify-rails

browserify-rails + babel のサンプル

## 作成手順

### 前提

* rbenvのインストール
* ndenvのインストール


### rails

```
cd browserify-rails
bundle init
```

`Gemfile`を修正

```
source "https://rubygems.org"
gem "rails"
```

```
bundle install --path vendor/bundle
bundle exec rails new .
```

※Gemfileを上書きすること

#### テスト用コントローラ作成

```
bin/rails g controller hello index
bin/rails s
```

http://localhost:3000/hello/index でアクセスできる

app/assets/javascripts/hello.js を適当に作成してJavaScriptが動くことを確認する。
（なおhello.coffee）は削除する


### browserify-rails

gemに以下を追加する

```
gem "browserify-rails"
bundle install
```
