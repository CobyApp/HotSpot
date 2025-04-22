import SwiftUI
import CobyDS

struct EmptyResults: View {
    let searchText: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 48))
                .foregroundColor(Color.labelAssistive)
            
            Text(searchText.isEmpty ? "店舗名で検索してください" : "検索結果が見つかりません")
                .font(.pretendard(size: 16, weight: .medium))
                .foregroundColor(Color.labelAssistive)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundNormalNormal)
    }
} 
