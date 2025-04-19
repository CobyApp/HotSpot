import UIKit

public enum ShopGenre {
    public static func name(for genreCode: String) -> String {
        switch genreCode {
        case "G001": return "居酒屋"
        case "G002": return "ダイニングバー・バル"
        case "G003": return "創作料理"
        case "G004": return "和食"
        case "G005": return "洋食"
        case "G006": return "イタリアン・フレンチ"
        case "G007": return "中華"
        case "G008": return "焼肉・ホルモン"
        case "G009": return "アジア・エスニック料理"
        case "G010": return "各国料理"
        case "G011": return "カラオケ・パーティ"
        case "G012": return "バー・カクテル"
        case "G013": return "ラーメン"
        case "G014": return "カフェ・スイーツ"
        case "G015": return "その他グルメ"
        case "G016": return "お好み焼き・もんじゃ"
        case "G017": return "韓国料理"
        default: return "その他"
        }
    }
    
    public static func color(for genreCode: String) -> UIColor {
        switch genreCode {
        case "G001": return UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0) // 居酒屋 - Red
        case "G002": return UIColor(red: 0.6, green: 0.4, blue: 0.8, alpha: 1.0) // ダイニングバー・バル - Purple
        case "G003": return UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1.0) // 創作料理 - Blue
        case "G004": return UIColor(red: 0.8, green: 0.6, blue: 0.2, alpha: 1.0) // 和食 - Orange
        case "G005": return UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0) // 洋食 - Green
        case "G006": return UIColor(red: 0.8, green: 0.4, blue: 0.6, alpha: 1.0) // イタリアン・フレンチ - Pink
        case "G007": return UIColor(red: 0.8, green: 0.2, blue: 0.4, alpha: 1.0) // 中華 - Deep Pink
        case "G008": return UIColor(red: 0.4, green: 0.2, blue: 0.2, alpha: 1.0) // 焼肉・ホルモン - Brown
        case "G017": return UIColor(red: 0.6, green: 0.2, blue: 0.2, alpha: 1.0) // 韓国料理 - Dark Red
        case "G009": return UIColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1.0) // アジア・エスニック料理 - Dark Blue
        case "G010": return UIColor(red: 0.4, green: 0.6, blue: 0.2, alpha: 1.0) // 各国料理 - Olive
        case "G011": return UIColor(red: 0.8, green: 0.4, blue: 0.2, alpha: 1.0) // カラオケ・パーティ - Orange
        case "G012": return UIColor(red: 0.6, green: 0.2, blue: 0.6, alpha: 1.0) // バー・カクテル - Purple
        case "G013": return UIColor(red: 0.2, green: 0.8, blue: 0.6, alpha: 1.0) // ラーメン - Teal
        case "G016": return UIColor(red: 0.8, green: 0.6, blue: 0.4, alpha: 1.0) // お好み焼き・もんじゃ - Light Brown
        case "G014": return UIColor(red: 0.6, green: 0.8, blue: 0.2, alpha: 1.0) // カフェ・スイーツ - Light Green
        case "G015": return UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0) // その他グルメ - Gray
        default: return .black
        }
    }
    
    public static func image(for genreCode: String) -> UIImage? {
        switch genreCode {
        case "G001": return UIImage(systemName: "wineglass.fill") // 居酒屋
        case "G002": return UIImage(systemName: "wineglass") // ダイニングバー・バル
        case "G003": return UIImage(systemName: "fork.knife") // 創作料理
        case "G004": return UIImage(systemName: "leaf.fill") // 和食
        case "G005": return UIImage(systemName: "fork.knife.circle") // 洋食
        case "G006": return UIImage(systemName: "fork.knife.circle.fill") // イタリアン・フレンチ
        case "G007": return UIImage(systemName: "bowl.fill") // 中華
        case "G008": return UIImage(systemName: "flame.fill") // 焼肉・ホルモン
        case "G017": return UIImage(systemName: "bowl") // 韓国料理
        case "G009": return UIImage(systemName: "globe.asia.australia.fill") // アジア・エスニック料理
        case "G010": return UIImage(systemName: "globe") // 各国料理
        case "G011": return UIImage(systemName: "music.mic") // カラオケ・パーティ
        case "G012": return UIImage(systemName: "wineglass") // バー・カクテル
        case "G013": return UIImage(systemName: "bowl") // ラーメン
        case "G016": return UIImage(systemName: "flame") // お好み焼き・もんじゃ
        case "G014": return UIImage(systemName: "cup.and.saucer.fill") // カフェ・スイーツ
        case "G015": return UIImage(systemName: "questionmark.circle.fill") // その他グルメ
        default: return UIImage(systemName: "mappin.circle.fill")
        }
    }
} 