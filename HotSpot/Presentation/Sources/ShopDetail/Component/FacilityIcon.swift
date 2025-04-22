import SwiftUI
import CobyDS

struct FacilityIcon: View {
    let systemName: String
    let title: String
    let isAvailable: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isAvailable ? Color.labelNormal.opacity(0.1) : Color.labelAlternative.opacity(0.1))
                    .frame(width: 56, height: 56)
                
                if isAvailable {
                    Image(systemName: systemName)
                        .font(.system(size: 28))
                        .foregroundColor(Color.labelNormal)
                } else {
                    ZStack {
                        Image(systemName: systemName)
                            .font(.system(size: 28))
                            .foregroundColor(Color.labelAlternative)
                        
                        Rectangle()
                            .fill(Color.labelAlternative)
                            .frame(width: 36, height: 2)
                            .rotationEffect(.degrees(45))
                    }
                }
            }
            
            Text(title)
                .font(.pretendard(size: 12, weight: .regular))
                .foregroundColor(isAvailable ? Color.labelNormal : Color.labelAlternative)
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    HStack(spacing: 0) {
        FacilityIcon(
            systemName: "wifi",
            title: "Wi-Fi",
            isAvailable: true
        )
        .frame(maxWidth: .infinity)
        
        FacilityIcon(
            systemName: "door.left.hand.open",
            title: "個室",
            isAvailable: false
        )
        .frame(maxWidth: .infinity)
    }
} 