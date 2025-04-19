import SwiftUI
import MapKit
import ComposableArchitecture
import CobyDS
import Kingfisher

struct MapView: View {
    let store: StoreOf<MapStore>
    @State private var shopImages: [String: UIImage] = [:]
    @State private var lastRegion: MKCoordinateRegion?

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                TopBarView(
                    leftSide: .title,
                    leftTitle: "HotSpot",
                    rightSide: .icon,
                    rightIcon: UIImage.icSearch,
                    rightAction: {
                        viewStore.send(.showSearch)
                    }
                )

                ZStack(alignment: .bottom) {
                    MapRepresentableView(
                        shops: viewStore.visibleShops,
                        region: viewStore.binding(
                            get: { $0.region },
                            send: { .updateRegion($0) }
                        )
                    )
                    .ignoresSafeArea(.all, edges: .bottom)

                    // Bottom card scroll view
                    SnappingScrollView(
                        items: viewStore.visibleShops,
                        itemWidth: BaseSize.fullWidth
                    ) { shop in
                        ThumbnailTileView(
                            image: shopImages[shop.id],
                            title: shop.name,
                            subTitle: nil,
                            description: shop.access,
                            subDescription: nil
                        )
                        .frame(width: BaseSize.fullWidth)
                        .onTapGesture {
                            viewStore.send(.showShopDetail(shop))
                        }
                        .onAppear {
                            loadImage(for: shop)
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
        }
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
