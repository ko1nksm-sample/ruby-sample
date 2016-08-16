# Railsのいろんな使い方

## 基本的な手順

### 初期化

Gemfile生成

```
bundle init
```

gemsをvendor/bundleにインストール

```
bundle install --path vendor/bundle
```


### アプリケーション作成

```
cd rails-various
bundle exec rails new .
```

※vendor/bundleにインストールしたrailsを使用するためにディレクトリに
移動してからカレントディレクトリに対して実行している。
またGemfileを上書きする必要がある。

これ以降bin/railsが使用できるようになる。

### コントローラ作成

```
bin/rails generate controller orders index
```


### データベース作成

```
bin/rake db:create
```

モデル作成

```
bin/rails g model Order name:string address:string
```

※モデルは単数形で作成すること


マイグレート

```
bin/rake db:migrate
```

データ投入

```
bin/rake db:seed
```


### 注文機能作成

* orders#index の作成
* orders#show の作成
* orders#new, orders#create の作成
* orders#edit, orders#update の作成
* orders#destroy の作成

### 注文明細作成

モデル作成

```
bin/rails g model Detail order_id:integer product:string quantity:integer
bin/rake db:migrate
```


### devise

Gemfileに`devise`を追加して`bundle`


ファイル作成

```
bin/rails g devise:install
```

メッセージに従い設定を行う。


コントローラ作成

```
bin/rails g controller Home index show
```

モデル作成

```
bin/rails g devise User
```

## その他

### コマンドいろいろ

サーバー起動

```
bin/rails server
# または bin/rails s
```

タスク一覧表示

```
bin/rake --tasks
# または bin/rails -T
```

ルーティング表示

```
bin/rake routes
```

### 参考

* [1対多の関係で同時に作成/更新する](http://pistachio0416.hatenablog.com/entry/2015/02/16/1%E5%AF%BE%E5%A4%9A%E3%81%AE%E9%96%A2%E4%BF%82%E3%81%A7%E5%90%8C%E6%99%82%E3%81%AB%E4%BD%9C%E6%88%90/%E6%9B%B4%E6%96%B0%E3%81%99%E3%82%8B)
* [Railsでaccepts_nested_attributes_forとfields_forを使ってhas_many関連の子レコードを作成/更新するフォームを作成](http://ruby-rails.hatenadiary.com/entry/20141208/1418018874)

* [nested_form はもう古い！？ Cocoon で作る1対多のフォーム](http://qiita.com/Matsushin/items/4829e12da2834d6e386e)