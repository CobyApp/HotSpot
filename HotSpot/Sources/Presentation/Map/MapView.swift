import SwiftUI

import ComposableArchitecture
import CobyDS
import Kingfisher

struct MapView: View {
    let store: StoreOf<MapStore>
    @State private var shopImages: [String: UIImage] = [:]

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
                        shops: viewStore.shops,
                        centerCoordinate: viewStore.binding(
                            get: { ($0.centerLat, $0.centerLng) },
                            send: { .updateCoordinates(lat: $0.0, lng: $0.1) }
                        ),
                        onRegionChanged: { center in
                            viewStore.send(.updateCoordinates(lat: center.latitude, lng: center.longitude))
                        }
                    )
                    .ignoresSafeArea(.all, edges: .bottom)

                    // Bottom card scroll view
                    SnappingScrollView(
                        items: viewStore.shops,
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
                            viewStore.send(.showShopDetail(shop.id))
                        }
                        .onAppear {
                            loadImage(for: shop)
                        }
                    }
                    .frame(height: 120)
                    .padding(.bottom, 30)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }

    private func loadImage(for shop: ShopModel) {
        guard shopImages[shop.id] == nil else { return }

        UIImage.load(from: shop.imageUrl) { image in
            DispatchQueue.main.async {
                shopImages[shop.id] = image
            }
        }
    }
}
