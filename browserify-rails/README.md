# browserify-rails

browserify-rails + babel のサンプル

## 概要

* railsと連携し
* browserifyでnodeモジュールを使えるようにし
* その際にbebelを通してES6対応をし
* jasmine-railsを使ってテストを行う


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

spec/javascripts/hello_spec.js

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

#### browserify-railsとテスト連携


spec/javascripts/support/jasmine.yml から application.js の実行を取り除く
（モジュール単位でテストするので不要）

```
src_files:
#  - "application.{js.coffee,js,coffee}"
```


`config/application.rb`に以下を追加
（テストコードをbrowserifyするため）

```
config.browserify_rails.paths << -> (p) { p.start_with?(Rails.root.join("spec/javascripts").to_s) }
```



テストコード修正

spec/javascripts/hello_spec.jp

```
import hello from 'hello'

function add(a, b) {
      return a + b;
}

describe('add 関数のテスト', function() {
    it('hello', function() {
        expect(hello()).toBe("hello");
    });

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

## 注意点

browserifyやbabelの設定を変えた後は`bin/rake tmp:cache:clear`を行わないとキャッシュが使われてハマる
