import UIKit

public enum Genre: String, CaseIterable {
    case izakaya = "G001"           // 居酒屋
    case diningBar = "G002"         // ダイニングバー・バル
    case creative = "G003"          // 創作料理
    case japanese = "G004"          // 和食
    case western = "G005"           // 洋食
    case italianFrench = "G006"     // イタリアン・フレンチ
    case chinese = "G007"           // 中華
    case yakiniku = "G008"          // 焼肉・ホルモン
    case asian = "G009"             // アジア・エスニック料理
    case international = "G010"     // 各国料理
    case karaoke = "G011"           // カラオケ・パーティ
    case bar = "G012"               // バー・カクテル
    case ramen = "G013"             // ラーメン
    case cafe = "G014"              // カフェ・スイーツ
    case okonomiyaki = "G016"       // お好み焼き・もんじゃ
    case korean = "G017"            // 韓国料理
    case other = "G015"             // その他グルメ
    
    public var name: String {
        switch self {
        case .izakaya: return "居酒屋"
        case .diningBar: return "ダイニングバー・バル"
        case .creative: return "創作料理"
        case .japanese: return "和食"
        case .western: return "洋食"
        case .italianFrench: return "イタリアン・フレンチ"
        case .chinese: return "中華"
        case .yakiniku: return "焼肉・ホルモン"
        case .asian: return "アジア・エスニック料理"
        case .international: return "各国料理"
        case .karaoke: return "カラオケ・パーティ"
        case .bar: return "バー・カクテル"
        case .ramen: return "ラーメン"
        case .cafe: return "カフェ・スイーツ"
        case .okonomiyaki: return "お好み焼き・もんじゃ"
        case .korean: return "韓国料理"
        case .other: return "その他グルメ"
        }
    }
    
    public var color: UIColor {
        switch self {
        case .izakaya: return UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
        case .diningBar: return UIColor(red: 0.6, green: 0.4, blue: 0.8, alpha: 1.0)
        case .creative: return UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1.0)
        case .japanese: return UIColor(red: 0.8, green: 0.6, blue: 0.2, alpha: 1.0)
        case .western: return UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0)
        case .italianFrench: return UIColor(red: 0.8, green: 0.4, blue: 0.6, alpha: 1.0)
        case .chinese: return UIColor(red: 0.8, green: 0.2, blue: 0.4, alpha: 1.0)
        case .yakiniku: return UIColor(red: 0.4, green: 0.2, blue: 0.2, alpha: 1.0)
        case .asian: return UIColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1.0)
        case .international: return UIColor(red: 0.4, green: 0.6, blue: 0.2, alpha: 1.0)
        case .karaoke: return UIColor(red: 0.8, green: 0.4, blue: 0.2, alpha: 1.0)
        case .bar: return UIColor(red: 0.6, green: 0.2, blue: 0.6, alpha: 1.0)
        case .ramen: return UIColor(red: 0.2, green: 0.8, blue: 0.6, alpha: 1.0)
        case .cafe: return UIColor(red: 0.6, green: 0.8, blue: 0.2, alpha: 1.0)
        case .okonomiyaki: return UIColor(red: 0.8, green: 0.6, blue: 0.4, alpha: 1.0)
        case .korean: return UIColor(red: 0.6, green: 0.2, blue: 0.2, alpha: 1.0)
        case .other: return UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        }
    }
    
    public var image: UIImage? {
        switch self {
        case .izakaya: return UIImage(systemName: "wineglass.fill")
        case .diningBar: return UIImage(systemName: "wineglass")
        case .creative: return UIImage(systemName: "fork.knife")
        case .japanese: return UIImage(systemName: "leaf.fill")
        case .western: return UIImage(systemName: "fork.knife.circle")
        case .italianFrench: return UIImage(systemName: "fork.knife.circle.fill")
        case .chinese: return UIImage(systemName: "bowl.fill")
        case .yakiniku: return UIImage(systemName: "flame.fill")
        case .asian: return UIImage(systemName: "globe.asia.australia.fill")
        case .international: return UIImage(systemName: "globe")
        case .karaoke: return UIImage(systemName: "music.mic")
        case .bar: return UIImage(systemName: "wineglass")
        case .ramen: return UIImage(systemName: "bowl")
        case .cafe: return UIImage(systemName: "cup.and.saucer.fill")
        case .okonomiyaki: return UIImage(systemName: "flame")
        case .korean: return UIImage(systemName: "bowl")
        case .other: return UIImage(systemName: "questionmark.circle.fill")
        }
    }
    
    public static func from(code: String) -> Genre? {
        return Genre(rawValue: code)
    }
} 
