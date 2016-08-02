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
bundle
```

`package.json`を作成

```
{
  "name": "browserify-rails",
  "private": true
}
```

```
npm install browserify browserify-incremental --save
npm install babelify babel-preset-es2015 babel-plugin-transform-es2015-modules-commonjs --save-dev
```

`.babelrc`を作成

```
{
  "presets": ["es2015"],
  "plugins": ["transform-es2015-modules-commonjs"]
}
```

`config/application.rb`に以下を追加

```
config.browserify_rails.commandline_options = '-t babelify --extension=.es6 --plugins transform-es2015-modules-commonjs'
```

**解説**

* JavaScriptファイルは拡張子.js、モジュールは拡張子.es6で作成するものとする。
* 拡張子.jsのファイルはAsset pipelineによって結合される。
* 拡張子.es6のファイルはbrowserify-railsによって結合される。

* ファイルの中にimportまたはmodule.exportsが含まれているとbrowserify+babelifyされる。
+ ただしexport文を使用してコードを書くとmodule.exportsを使用しないので拡張子es6をモジュールとして認識させる (--extension=.es6)
* さらにtransform-es2015-modules-commonjsによってcommonjs形式のモジュールに変換する。
