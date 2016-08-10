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
