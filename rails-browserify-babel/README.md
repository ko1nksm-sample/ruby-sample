# browserify-rails(+babel)を使ったRailsとJavaScriptの連携

browserify-rails(+babel)を使ったRailsとJavaScriptの連携方法です。
またJavaScript側は開発で必要となるものを揃えています。

Rails標準のアセットパイプラインの仕組みに乗っかったやり方で、
フロントエンド（JavaScript）側のコードがそれほど多くない場合を想定しています。

フロントエンド側のコードが多い場合はビルドに時間がかかるようなので
webpackを使って連携させた方が良いでしょう。

## 構成

| 種類                   | ツール                                    |
| ---------------------- | ------------------------------------------|
| **Rails側**            |                                           |
| Ruby on Rails          | 5系（おそらく4系でも同じ）                |
| JavaScript連携         | browserify-rails                          |
|                        |                                           |
| **JavaScript側**       |                                           |
| タスクランナー         | npm                                       |
| トランスラパイラ       | babel (ES2015)                            |
| パッケージ管理         | npm                                       |
| テストフレームワーク   | mocha + power-assert                      |
| カバレッジ             | nyc (istanbul cli)                        |
| ブラウザテストランナー | karma, karma-coverage                     |
| 構文チェック           | eslint                                    |
| メトリクス計測         | plato                                     |

おまけ MacOSX上のatomでlinter-eslintプラグインが正常に動作することを確認済み


## 既存のRailsプロジェクトに組み込む方法

以下の設定ファイル（Rails）を行って、設定ファイル（JavaScript）のファイルをコピーして
npm installを行えば動くのではないかと・・・

## 設定ファイル（Rails）

標準のRailsのGemfileに以下の行を追加してbundle installします。

```
gem "browserify-rails"
```

config/application.rbに以下を追加します。（下の行はsource mapが必要な場合）

```
config.browserify_rails.commandline_options = '-t babelify'
config.browserify_rails.source_map_environments << "development"
```

assets/javascripts/application.jsを修正して読み込みたいファイルのみを記述します。

```
// require_tree .
//= require main.js
```

## 設定ファイル（JavaScript）

以下のファイルがJavaScript周りの設定ファイルです。

|  ファイル名    | 内容                                                          |
| -------------- | ------------------------------------------------------------- |
| .babelrc       | babelによるES2015対応 ＋ power-assert、istanbul用のコード変換 |
| .eslintignore  | Railsが生成したファイルなどeslintで無視するファイルを記述     |
| .eslintrc.yaml | eslint用設定                                                  |
| karma.conf.js  | karma用設定                                                   |
| mocha.opts     | テスト用設定                                                  |
| package.json   | パッケージ管理、タスク定義、nyc設定                           |

npm run で実行できるタスクはpackage.jsonを参照してください。

## 処理の流れと依存関係

### ビルド、開発用ウェブサーバー

Railsの通常のやり方と同じで、`rails server` や `rake assets:precompile` を使用します。

1. rails server実行 [設定ファイル: config/application.rb]
  * browserify実行（-t babelify）
2. browserify実行
  * -t オプションにてbabel実行
3. babel実行 [設定ファイル: .babelrc]
  * ES6変換 (babel-preset-es2015)
  * プロジェクトパス解決 (babel-plugin-resolver)

### テスト、カバレッジ (npn run test, npm run test-cov)

テストの場合は1を飛ばして「2. mocha実行」から開始

1. nyc実行 [設定ファイル: package.json]
2. mocha実行 [設定ファイル: mocha.opts]
  * babel実行 (--compilers js:babel-core/register)
  * instrument追加 (babel-plugin-istanbul)
3. babel実行
  * ビルド、開発用ウェブサーバー」の内容
  * power-assert変換 (babel-preset-power-assert)
  * instrumentコード埋め込み (babel-plugin-istanbul)

### ブラウザテスト、カバレッジ (npm run karma)

1. karma実行 [設定ファイル: karma.conf.js]
  * browserify実行 (karma-browserify)
  * babel実行 (babelify)
  * PhantomJS実行（karma-phantomjs-launcher）
  * mocha実行 (karma-mocha)
  * カバレッッジ実行 (karma-coverage)

### 構文チェック (npm run lint)

1. eslint実行 [設定ファイル: .eslintrc.yaml]
  * nodeモジュールのパス解決 (eslint-import-resolver-node)

### メトリクス (npm run metrics)

1. plato実行 (特に依存するものはない)


## 注意点

browserifyやbabelの設定を変えた後は`bin/rake tmp:cache:clear`を行わないとキャッシュが使われることがあります。

