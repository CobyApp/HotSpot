import Foundation

struct ShopErrorMessageMapper {
    static func message(for error: ShopError) -> String {
        switch error {
        case .network:
            return "ネットワークに接続できません。通信環境をご確認ください。"
        case .decoding:
            return "データの解析に失敗しました。"
        case let .server(message):
            return "サーバーエラー: \(message)"
        case .unknown:
            return "不明なエラーが発生しました。"
        }
    }
}
