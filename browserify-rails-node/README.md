# browserify-railsを使ったRailsとJavaScriptの連携（2016年8月版）

browserify-railsを使ったRailsとJavaScriptの連携方法です。
またJavaScript側は開発で必要となるものを揃えています。

Rails標準のアセットパイプラインの仕組みに乗っかったやり方で、
フロントエンド（JavaScript）側のコードがそれほど多くない場合を想定しています。

フロントエンド側のコードが多い場合はwebpackを使って連携させた方が良いでしょう。

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


## 設定ファイル（Rails）

標準のRailsのGemfileに以下の行を追加します。

```
gem "browserify-rails"
```

config/application.rbに以下を追加します。

```
config.browserify_rails.commandline_options = '-t babelify'
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
| mocha.opts     | テスト用設定                                                  |
| package.json   | パッケージ管理、タスク定義、nyc設定                           |

npm run で実行できるタスクはpackage.jsonを参照してください。


## 注意点

browserifyやbabelの設定を変えた後は`bin/rake tmp:cache:clear`を行わないとキャッシュが使われることがあります。

