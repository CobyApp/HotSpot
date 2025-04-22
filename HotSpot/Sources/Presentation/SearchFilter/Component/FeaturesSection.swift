import SwiftUI
import CobyDS

struct FeaturesSection: View {
    let wifi: Int
    let privateRoom: Int
    let nonSmoking: Int
    let parking: Int
    let onWiFiTapped: () -> Void
    let onPrivateRoomTapped: () -> Void
    let onNonSmokingTapped: () -> Void
    let onParkingTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("設備・サービス")
                .font(.pretendard(size: 16, weight: .semibold))
                .foregroundColor(Color.labelNormal)
            
            HStack(spacing: 8) {
                FeatureButton(
                    title: "Wi-Fiあり",
                    isSelected: wifi != 0,
                    action: onWiFiTapped
                )
                
                FeatureButton(
                    title: "個室あり",
                    isSelected: privateRoom != 0,
                    action: onPrivateRoomTapped
                )
                
                FeatureButton(
                    title: "禁煙席あり",
                    isSelected: nonSmoking != 0,
                    action: onNonSmokingTapped
                )
                
                FeatureButton(
                    title: "駐車場あり",
                    isSelected: parking != 0,
                    action: onParkingTapped
                )
            }
        }
        .padding(.horizontal, BaseSize.horizantalPadding)
    }
}

private struct FeatureButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(isSelected ? .white : .black)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .cornerRadius(16)
        }
    }
}

#Preview {
    FeaturesSection(
        wifi: 1,
        privateRoom: 0,
        nonSmoking: 1,
        parking: 0,
        onWiFiTapped: {},
        onPrivateRoomTapped: {},
        onNonSmokingTapped: {},
        onParkingTapped: {}
    )
} 
