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

Gemfileに以下を追加して`bundle`を実行する

```
gem "browserify-rails"
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

### テスト

Gemfileに以下を追加して`bundle`を実行する

```
group :development, :test do
  gem 'jasmine-rails'
end
```

jasmine_railsをインストールする

```
bin/rails g jasmine_rails:install
```

テストコードを書く

spec/javascripts/hello_spec.jp

```
function add(a, b) {
      return a + b;
}

describe('add 関数のテスト', function() {
    it('1 + 1 は 2', function() {
        expect(add(1, 1)).toBe(2);
    });
    it('1 + 4 は 5', function() {
        expect(add(1, 4)).toBe(5);
    });
});
```

テスト実行

```
bin/rake spec:javascript
```
