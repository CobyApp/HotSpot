import SwiftUI
import CoreLocation

import CobyDS
import ComposableArchitecture

struct SearchView: View {
    let store: StoreOf<SearchStore>
    @FocusState private var isSearchFocused: Bool
    @State private var localSearchText: String = ""
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                if !isSearchFocused {
                    TopBarView(
                        leftSide: .left,
                        leftAction: {
                            viewStore.send(.pop)
                        },
                        title: "Search"
                    )
                }
                
                // Search Bar
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("검색어를 입력하세요", text: $localSearchText)
                        .textFieldStyle(.plain)
                        .focused($isSearchFocused)
                        .onChange(of: localSearchText) { newValue in
                            viewStore.send(.searchTextChanged(newValue))
                        }
                        .onSubmit {
                            if !localSearchText.isEmpty {
                                isSearchFocused = false
                                viewStore.send(.search)
                            }
                        }
                        .submitLabel(.search)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    if !localSearchText.isEmpty {
                        Button {
                            localSearchText = ""
                            viewStore.send(.searchTextChanged(""))
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    if isSearchFocused {
                        Button {
                            localSearchText = ""
                            viewStore.send(.searchTextChanged(""))
                            isSearchFocused = false
                        } label: {
                            Text("취소")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.top, isSearchFocused ? 16 : 0)
                .animation(.easeInOut, value: isSearchFocused)
                
                // Search Results
                ZStack {
                    if viewStore.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewStore.shops.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                            Text(viewStore.searchText.isEmpty ? "검색어를 입력해주세요" : "검색 결과가 없습니다")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(viewStore.shops) { shop in
                                    ShopCell(shop: shop)
                                        .onTapGesture {
                                            viewStore.send(.selectShop(shop))
                                        }
                                    
                                    if shop.id != viewStore.shops.last?.id {
                                        Divider()
                                            .padding(.leading)
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationBarHidden(true)
            .onTapGesture {
                isSearchFocused = false
            }
        }
    }
}

#Preview {
    SearchView(
        store: Store(
            initialState: SearchStore.State(),
            reducer: { SearchStore() }
        )
    )
} 
