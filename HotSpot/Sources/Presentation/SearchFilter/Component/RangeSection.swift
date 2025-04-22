import SwiftUI
import CobyDS

struct RangeSection: View {
    let selectedRange: Int
    let onRangeSelected: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("距離")
                .font(.pretendard(size: 16, weight: .semibold))
                .foregroundColor(Color.labelNormal)
                .padding(.horizontal, BaseSize.horizantalPadding)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Range.allCases, id: \.self) { range in
                        FilterButton(
                            title: range.name,
                            isSelected: selectedRange == range.rawValue,
                            action: { onRangeSelected(range.rawValue) }
                        )
                    }
                }
                .padding(.horizontal, BaseSize.horizantalPadding)
            }
        }
    }
} 
