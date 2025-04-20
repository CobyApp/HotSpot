import SwiftUI
import CobyDS
import Kingfisher

struct SearchResults: View {
    let error: String?
    let searchText: String
    let shops: [ShopModel]
    let onSelectShop: (ShopModel) -> Void
    let onLoadMore: () -> Void
    @State private var shopImages: [String: UIImage] = [:]
    
    var body: some View {
        Group {
            if let error = error {
                Text(error)
                    .foregroundColor(.red)
            } else if searchText.isEmpty {
                EmptyResults(searchText: searchText)
            } else if shops.isEmpty {
                EmptyResults(searchText: searchText)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(shops) { shop in
                            ThumbnailTileView(
                                image: shopImages[shop.id],
                                title: shop.name,
                                subTitle: nil,
                                description: shop.access,
                                subDescription: nil
                            )
                            .frame(width: BaseSize.fullWidth)
                            .onTapGesture {
                                onSelectShop(shop)
                            }
                            .onAppear {
                                loadImage(for: shop)
                                if shop.id == shops.last?.id {
                                    onLoadMore()
                                }
                            }
                        }
                    }
                    .padding()
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func loadImage(for shop: ShopModel) {
        guard shopImages[shop.id] == nil else { return }
        
        UIImage.loadThumbnail(from: shop.imageUrl) { image in
            DispatchQueue.main.async {
                shopImages[shop.id] = image
            }
        }
    }
}
