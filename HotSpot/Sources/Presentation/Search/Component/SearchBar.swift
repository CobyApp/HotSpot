import SwiftUI

struct SearchBar: View {
    let searchText: String
    let onSearch: (String) -> Void
    @FocusState var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("검색어를 입력하세요", text: .init(
                get: { searchText },
                set: { onSearch($0) }
            ))
            .textFieldStyle(.plain)
            .focused($isFocused)
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
    }
} 
