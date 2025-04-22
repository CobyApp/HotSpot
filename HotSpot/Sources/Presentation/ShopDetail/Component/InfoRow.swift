import SwiftUI
import CobyDS

struct InfoRow: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.pretendard(size: 16, weight: .semibold))
                .foregroundColor(Color.labelNormal)
            
            Text(content)
                .font(.pretendard(size: 16, weight: .regular))
                .foregroundColor(Color.labelNeutral)
        }
    }
}

#Preview {
    InfoRow(
        title: "予算",
        content: "¥1,501〜¥2,000"
    )
} 