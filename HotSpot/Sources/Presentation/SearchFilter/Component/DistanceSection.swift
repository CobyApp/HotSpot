import SwiftUI

struct DistanceSection: View {
    let selectedDistance: String
    let onDistanceSelected: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("거리")
                .font(.system(size: 17, weight: .semibold))
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(["1", "2", "3", "5", "10"], id: \.self) { distance in
                        Button {
                            onDistanceSelected(distance)
                        } label: {
                            Text("\(distance)km")
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
} 