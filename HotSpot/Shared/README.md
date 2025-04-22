# Shared モジュール

## 概要
Sharedモジュールは、アプリケーションの共通機能とコンポーネントを提供します。

## 構造
```
Shared/
├── Sources/
│   ├── Common/      # 共通で使用されるコンポーネント
│   ├── Extensions/  # Swift基本型の拡張
│   ├── Utils/       # ユーティリティ関数
│   └── Dependency/  # 依存性注入
└── Tests/           # ユニットテスト
```

## 依存関係
- ComposableArchitecture

## 使用方法
Sharedモジュールは、他のすべてのモジュールで使用できる共通機能を提供します. 