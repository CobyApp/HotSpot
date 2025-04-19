import SwiftUI
import CobyDS
import Kingfisher

struct SearchResults: View {
    let error: String?
    let searchText: String
    let shops: [ShopModel]
    let onSelectShop: (ShopModel) -> Void
    @State private var shopImages: [String: UIImage] = [:]
    
    var body: some View {
        Group {
            if let error = error {
                Text(error)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                            }
                        }
                    }
                    .padding()
                }
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
