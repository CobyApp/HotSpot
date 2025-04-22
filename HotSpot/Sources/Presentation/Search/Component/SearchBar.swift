import SwiftUI
import CobyDS

struct SearchBar: View {
    let searchText: String
    let onSearch: (String) -> Void
    @FocusState private var isFocused: Bool
    @Binding var isSearchFocused: Bool
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage.icSearch)
                .foregroundColor(Color.labelAssistive)
            
            TextField("店舗名で検索", text: .init(
                get: { searchText },
                set: { onSearch($0) }
            ))
            .textFieldStyle(.plain)
            .focused($isFocused)
            
            if isSearchFocused {
                Button {
                    isFocused = false
                } label: {
                    Text("キャンセル")
                        .font(.pretendard(size: 14, weight: .medium))
                        .foregroundColor(Color.labelNeutral)
                }
                .transition(.opacity)
            }
        }
        .padding(8)
        .background(Color.fillNormal)
        .cornerRadius(8)
        .onChange(of: isFocused) { newValue in
            withAnimation(.easeInOut(duration: 0.3)) {
                isSearchFocused = newValue
            }
        }
        .onChange(of: isSearchFocused) { newValue in
            withAnimation(.easeInOut(duration: 0.3)) {
                isFocused = newValue
            }
        }
    }
} 
