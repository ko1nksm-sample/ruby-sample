# browserify-rails-teaspoon

browserify-rails + babel + teaspoon のサンプル

## 概要

* railsと連携し
* browserifyでnodeモジュールを使えるようにし
* その際にbebelを通してES6対応をし
* teaspoonを使ってテストを行う

**webpackを使用しなかった理由**

webpackだとRailsとの連携部分を独自で作りこむ必要があり大変そうだったから。
（将来Railsが標準で対応したりベストプラクティスが作られることに期待）

フロントエンドにReactを使ったりgulpを導入して、Railsと分離したい場合はwebpackの方が良さそう。


## 作成手順

### 前提

bundleとnpmを使えるようにしておくこと

### rails

```
cd browserify-rails-teaspoon
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

app/assets/javascripts/hello.js を適当に作成してJavaScriptが動くことを確認する。
（なおhello.coffee）は削除する

```
bin/rails g controller hello index
echo 'alert("hello")' > app/assets/javascripts/hello.js
rm app/assets/javascripts/hello.coffee
bin/rails s
```

http://localhost:3000/hello/index でアクセスできる



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


`app/assets/javascripts/main.js`に以下を記述

```
import hello from 'hello'

let func = () => {
  console.log('main: ' + hello());
}

func();
```

`app/assets/javascripts/hello.es6`に以下を記述

```
export default function hello() {
  return 'hello';
}
```

`app/assets/javascripts/hello.js`は削除


**解説**

* 通常のJavaScriptファイルは拡張子.js、モジュールは拡張子.es6で作成するものとする。
* 拡張子.jsのファイルはAsset pipelineによって結合される。
* 拡張子.es6のファイルはbrowserify-railsによって結合される。
* ファイルの中にimportまたはmodule.exportsという文字列が含まれているとbrowserify-railsによってbrowserifyされる。
+ しかしexport文を使用してコードを書くとmodule.exportsという文字列が含まれないので拡張子.es6をモジュールとして認識させる (--extension=.es6)
* さらにtransform-es2015-modules-commonjsによってcommonjs形式のモジュールに変換することで作成したモジュールをimportできるようになる。

### テスト

phantomjsをインストールしておく

```
brew install phantomjs
```

Gemfileに以下を追加して`bundle`を実行する

```
group :development, :test do
  gem "teaspoon-jasmine"
end
```

teaspoonインストール

```
bin/rails generate teaspoon:install
```


teaspoonにブラウザからアクセス

```
bin/rails s
```

http://localhost:3000/teaspoon を開く



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

`spec/javascripts/support/spec_helper.js` から `//=require application` をコメントアウトする
（モジュール単位でテストするので不要）

```
// require application
```

テスト実行

```
bundle exec rake teaspoon
```

※ `bin/rake` だとエラーになるので注意


#### browserify-railsとテスト連携


`config/application.rb`に以下を追加（テストコードをbrowserifyするため）

```
config.browserify_rails.paths << -> (p) { p.start_with?(Rails.root.join("spec/javascripts").to_s) }
```


テストコード修正

spec/javascripts/hello_spec.js

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
bundle exec rake teaspoon
```

## 注意点

browserifyやbabelの設定を変えた後は`bin/rake tmp:cache:clear`を行わないとキャッシュが使われてハマる
