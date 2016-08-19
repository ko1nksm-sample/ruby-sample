# Ruby関連のサンプル

作りかけだったり不具合があったりするかもしれない。


## rails-scaffold

scaffold生成コード

```
rails new rails-scaffold
rails generate scaffold user name:string age:integer
```

## rails-blog

railsブログのサンプル

## browserify-rails-jasmine

railsは5。

フロントエンド（JavaScript）周りにbrowserify_rails(+babel)を使って連携させたもの。

フロントエンドのテストには jasmine-rails を使用している。
テストは問題なく動くがカバレッジの連携ができない。

## browserify-rails4.2-jasmine

上記のrails4.2版

## browserify-rails-teaspoon

フロントエンド（JavaScript）周りにbrowserify_railsを使って連携させたもの。

フロントエンドのテストには teaspoon を使用している。
teaspoonにはフロントエンドのカバレッジ出力機能があるのだが出力されない。
（babelを通しているのが原因？）

## browserify-rails-node

browserify-railsを使ってRailsとフロントエンドを連携させているが、
フロントエンドのテスト周りをnodeの世界で行うもの

テストにはjasmine、カバレッジにはispara（istanbulのes6対応ラッパー）を使用している。

eslintにも対応

比較的良好に動いている。

## おまけ

httpサーバー起動

```
ruby -run -e httpd . -p 8000
```