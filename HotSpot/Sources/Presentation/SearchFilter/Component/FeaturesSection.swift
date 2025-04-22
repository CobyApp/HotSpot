import SwiftUI
import CobyDS

struct FeaturesSection: View {
    let selectedFeatures: Set<String>
    let onFeatureSelected: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("特徴")
                .font(.pretendard(size: 16, weight: .semibold))
                .foregroundColor(Color.labelNormal)
                .padding(.horizontal, BaseSize.horizantalPadding)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Feature.allCases, id: \.self) { feature in
                        FilterButton(
                            title: feature.name,
                            isSelected: selectedFeatures.contains(feature.rawValue),
                            action: { onFeatureSelected(feature.rawValue) }
                        )
                    }
                }
                .padding(.horizontal, BaseSize.horizantalPadding)
            }
        }
    }
}

#Preview {
    FeaturesSection(
        selectedFeatures: ["Wi-Fiあり", "個室あり", "禁煙席あり", "駐車場あり"],
        onFeatureSelected: { _ in }
    )
} 
