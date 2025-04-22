import SwiftUI
import CobyDS

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.pretendard(size: 14, weight: .medium))
                .foregroundColor(isSelected ? Color.inverseLabel : Color.labelNormal)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.labelNormal : Color.fillNormal)
                .cornerRadius(16)
        }
    }
}

#Preview {
    HStack(spacing: 8) {
        FilterButton(title: "選択済み", isSelected: true, action: {})
        FilterButton(title: "未選択", isSelected: false, action: {})
    }
    .padding()
} 
