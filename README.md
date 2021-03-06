# README

## このアプリについて
転職の際にポートフォリオが必要かと考え、このアプリを作成しました。
Twitterによく似た作りとなっていますが、当アプリは動物の写真を投稿したり、
投稿された動物をみたりすることが目的であり、    
投稿する側は「飼っているペットを自慢する。」    
閲覧する側は「アプリを開けばかわいい動物が見ることができる」    
をコンセプトとして作成しました。    
    
Ruby On Rails チュートリアルで作成したアプリを元に作成しました。    
元アプリとの主な相違点は,

#### ユーザー視点
- 投稿フォームの改良
- ユーザーアイコンの選択を画像トリミングで行えるよう実装(不具合があり))
- 投稿のシェア機能実装
- 投稿のお気に入り機能実装
- 投稿画像のプレビュー表示実装
- 検索機能実装
- シェア、お気に入りしたユーザーの一覧表示機能実装
- 投稿お気に入りランキング、トレンド一覧機能の実装

#### ベンダー視点
- ユーザー認証機能をsorceryにて実装
- インフラ部分にAWS,Dockerを使用
- ユーザーアイコン、投稿画像の管理方法変更(当アプリで管理する方式に変更 active storage)
    
リファクタリング、修正、テストコードなど必要な部分が多々あります。  
今後、修正していきます。

## わかりにくい仕様について
#### ホーム(ヘッダー左上)
自分の投稿と自分がシェアした投稿が表示されます。
#### 一覧(右のサイドメニュー1番目)
ユーザーの投稿、フォローしているユーザーの投稿、フォローしているユーザーがシェアした投稿が
表示されます。
#### お気に入り(右のサイドメニュー2番目)
お気に入りした投稿(投稿右下の肉球のボタンが押された投稿)が表示されます。
#### 注目(右のサイドメニュー3番目)
- トップ    
すべての投稿のなかで「お気に入り」された数が多い順、上位50の投稿が表示されます。
- トレンド  
一週間内のすべての投稿のなかで「お気に入り」された数が多い順、上位100の投稿が表示されます。

## こだわった部分
投稿画面で画像が4枚まで投稿できます。   
選択した画像を削除(選択取り消し)ができるようにしました。

## アドレス
http://3.132.247.165/