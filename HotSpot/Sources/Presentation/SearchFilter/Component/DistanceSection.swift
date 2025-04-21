import SwiftUI

struct DistanceSection: View {
    let selectedDistance: Int
    let onDistanceSelected: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("距離")
                .font(.system(size: 17, weight: .semibold))
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach([1, 2, 3, 4, 5], id: \.self) { distance in
                        Button {
                            onDistanceSelected(distance)
                        } label: {
                            Text(distanceText(for: distance))
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedDistance == distance ? Color.blue : Color(.systemGray6))
                                .foregroundColor(selectedDistance == distance ? .white : .primary)
                                .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private func distanceText(for distance: Int) -> String {
        switch distance {
        case 1: return "300m"
        case 2: return "500m"
        case 3: return "1km"
        case 4: return "2km"
        case 5: return "3km"
        default: return "1km"
        }
    }
} 