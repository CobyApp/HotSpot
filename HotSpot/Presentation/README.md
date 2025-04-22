# Presentation モジュール

## 概要
Presentationモジュールは、ユーザーインターフェースと画面遷移を担当します。

## 構造
```
Presentation/
├── Sources/
│   ├── Search/      # 検索機能
│   │   ├── View/    # ビュー
│   │   ├── Store/   # 状態管理
│   │   └── Component/ # UIコンポーネント
│   ├── Map/         # 地図機能
│   │   ├── View/
│   │   ├── Store/
│   │   └── Component/
│   └── ShopDetail/  # 店舗詳細
│       ├── View/
│       ├── Store/
│       └── Component/
└── Tests/           # ユニットテスト
```

## 依存関係
- Domainモジュール
- CobyDS
- Kingfisher

## 使用方法
Presentationモジュールは、ユーザーインターフェースの表示とユーザー操作の処理を担当します。
Domainモジュールのユースケースを使用してビジネスロジックを実行します。 