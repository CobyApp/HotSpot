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
                    ForEach([1, 2, 3, 4, 5], id: \.self) { range in
                        Button {
                            onRangeSelected(range)
                        } label: {
                            Text(rangeText(for: range))
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedRange == range ? Color.blue : Color(.systemGray6))
                                .foregroundColor(selectedRange == range ? .white : .primary)
                                .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal, BaseSize.horizantalPadding)
            }
        }
    }
    
    private func rangeText(for range: Int) -> String {
        switch range {
        case 1: return "300m"
        case 2: return "500m"
        case 3: return "1km"
        case 4: return "2km"
        case 5: return "3km"
        default: return "1km"
        }
    }
} 
