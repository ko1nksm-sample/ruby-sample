# browserify-rails-node

browserify-rails(+babel) と JavaScripテストのサンプル

## 概要

* browserify-railsでrailsとJavaScriptを連携させ
* browserifyでnodeモジュールを使えるようにし
* その際にbebelを通してES6対応する。
* JavaScript周りのテストはRailsと独立して行う

**webpackを使用しなかった理由**

webpackだとRailsとの連携部分を独自で作りこむ必要があり大変そうだったから。
（将来Railsが標準で対応したりベストプラクティスが作られることに期待）

フロントエンドにReactを使ったりgulpを導入して、Railsと分離したい場合はwebpackの方が良さそう。


## 作成手順

### 前提

bundleとnpmを使えるようにしておくこと

### rails

```
cd browserify-rails-node
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
なおhello.coffeeは削除する。

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
  "name": "browserify-rails-node",
  "private": true
}
```

```
npm install browserify browserify-incremental babelify babel-preset-es2015 babel-plugin-resolver --save-dev
```

.babelrcを作成

```
{
  "presets": ["es2015"],
  "plugins": [
    ["resolver", { "resolveDirs": ["app/assets/javascripts"] }]
  ]
}
```

config/application.rbに以下を追加

```
config.browserify_rails.commandline_options = '-t babelify'
```

assets/javascripts/application.jsを修正してすべてのjsファイルではなく読み込みたいファイルのみを記述する

```
// require_tree .
//= require main.js
```


app/assets/javascripts/main.jsに以下を記述

```
import hello from 'hello'

let func = () => {
  console.log('main: ' + hello());
}

func();
```

app/assets/javascripts/hello.jsに以下を記述

```
export default function hello() {
  return 'hello';
}
```

**注意点**

browserifyやbabelの設定を変えた後は`bin/rake tmp:cache:clear`を行わないとキャッシュが使われてprecompileでハマる

### テスト＋カバレッジ

JavaScriptのテストはRailsとは完全に独立させる

```
npm install --save-dev bebel-cli jasmine isparta
```

jasmineの設定ファイル生成

```
$(npm bin)/jasmine init
```

spec/support/jasmine.jsonのspec_dirを書き換える

```
  "spec_dir": "spec/javascripts",
```

テストコードを書く

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
$(npm bin)/babel-node $(npm bin)/isparta cover --report text --report html node_modules/jasmine/bin/jasmine.js
```

#### ESLint

ついでにESLintもインストールする

```
npm install --save-dev eslint
```

```
$(npm bin)/eslint --init
```

適当に.eslintrcファイルを作成する。

```
$(npm bin)/eslint app/assets/javascripts
```

#### 簡略化

テストの実行を簡単にするためのスクリプトを作成する


package.jsonに以下を追加する

```
  "scripts": {
    "eslint": "eslint app/assets/javascripts",
    "test": "babel-node $(npm bin)/jasmine",
    "test-cov": "babel-node $(npm bin)/isparta cover --report text --report html node_modules/jasmine/bin/jasmine.js"
  }
```

コマンド

```
npm run eslint
npm run test
npm run test-cov
```
