# 簡易仕様書

### 作者
金 挑永

### アプリ名
HotSpot

#### コンセプト
食べに行きたいお店がすぐ見つかる。

#### こだわったポイント
- モダンなUI/UXデザイン
- 高速な検索機能
- 直感的な操作性

### 公開したアプリの URL（Store にリリースしている場合）
準備中

### 該当プロジェクトのリポジトリ URL
https://github.com/CobyApp/HotSpot

## 開発環境
### 開発環境
Xcode 16.3

### 開発言語
Swift 5.9

### テーブル定義(ER図)などの設計ドキュメント

#### 店舗情報 (Shop)
| カラム名 | 型 | 説明 | 制約 |
|---------|----|------|------|
| id | String | 店舗ID | NOT NULL |
| name | String | 店舗名 | NOT NULL |
| address | String | 住所 | NOT NULL |
| latitude | Double | 緯度 | NOT NULL |
| longitude | Double | 経度 | NOT NULL |
| image_url | String | 画像URL | NOT NULL |
| access | String | アクセス情報 | NOT NULL |
| opening_hours | String | 営業時間 | NOT NULL |
| genre | String | ジャンル | NOT NULL |
| budget | String | 予算 | NOT NULL |
| url | String | 店舗URL | NOT NULL |
| wifi | Int | WiFi有無 | NOT NULL |
| private_room | Int | 個室有無 | NOT NULL |
| non_smoking | Int | 禁煙有無 | NOT NULL |
| parking | Int | 駐車場有無 | NOT NULL |

#### 検索結果 (SearchResult)
| カラム名 | 型 | 説明 | 制約 |
|---------|----|------|------|
| shops | [Shop] | 店舗リスト | NOT NULL |
| current_page | Int | 現在のページ | NOT NULL |
| has_more | Bool | 次のページ有無 | NOT NULL |
| total_count | Int | 総件数 | NOT NULL |

### 開発環境構築手順
1. リポジトリをクローン
```bash
git clone https://github.com/CobyApp/HotSpot
```

2. 依存関係のインストール
```bash
tuist install
```

3. プロジェクトの生成
```bash
tuist generate
```

## 動作対象端末・OS
### 動作対象OS
iOS 15.0以上

## 開発期間
5日間

## アプリケーション機能

### 機能一覧
- レストラン検索：現在地周辺の飲食店を検索する
- レストラン情報取得：飲食店の詳細情報を取得する
- 地図アプリ連携：飲食店の所在地を地図アプリに連携する

### 画面一覧
- **地図画面**
  - 画面に表示された範囲内の店舗のリストを取得
  - 店舗数が多い場合はクラスタリング適用
  - 店舗マーカーをタップすると、その店舗のカードタイルに焦点が当てられる

- **詳細画面**
  - お店の詳細情報を表示
  - お店のウェブサイトへのリンク
  - 地図アプリへの連携機能

- **検索画面**
  - 店舗名での検索機能
  - ローカルに保存されたフィルター条件の反映

- **フィルター画面**
  - タグ形式でのフィルター指定
  - リセットボタンによるフィルター内容の初期化

### 使用しているAPI,SDK,ライブラリなど
- Composable Architecture (TCA)
- Tuist
- Swift Package Manager
- Moya
- Kingfisher
- Coby DS
- HotPepper API
