import SwiftUI

struct FeaturesSection: View {
    let hasWiFi: Bool
    let hasPrivateRoom: Bool
    let isNonSmoking: Bool
    let hasParking: Bool
    let onWiFiTapped: () -> Void
    let onPrivateRoomTapped: () -> Void
    let onNonSmokingTapped: () -> Void
    let onParkingTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("設備・サービス")
                .font(.system(size: 17, weight: .semibold))
                .padding(.horizontal, 16)
            
            VStack(spacing: 16) {
                FeatureToggle(
                    title: "Wi-Fiあり",
                    isOn: hasWiFi,
                    onToggle: onWiFiTapped
                )
                
                FeatureToggle(
                    title: "個室あり",
                    isOn: hasPrivateRoom,
                    onToggle: onPrivateRoomTapped
                )
                
                FeatureToggle(
                    title: "禁煙",
                    isOn: isNonSmoking,
                    onToggle: onNonSmokingTapped
                )
                
                FeatureToggle(
                    title: "駐車場あり",
                    isOn: hasParking,
                    onToggle: onParkingTapped
                )
            }
            .padding(.horizontal, 16)
        }
    }
}

private struct FeatureToggle: View {
    let title: String
    let isOn: Bool
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16))
            Spacer()
            Toggle("", isOn: .init(
                get: { isOn },
                set: { _ in onToggle() }
            ))
            .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
} 