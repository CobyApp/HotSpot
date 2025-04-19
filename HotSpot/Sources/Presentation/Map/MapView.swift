import SwiftUI
import ComposableArchitecture
import CobyDS

struct MapView: View {
    let store: StoreOf<MapStore>

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
                            image: nil, // TODO: Connect with Kingfisher when image URL is available
                            title: shop.name,
                            subTitle: shop.access,
                            description: shop.address
                        )
                        .frame(width: BaseSize.fullWidth, height: 120)
                        .onTapGesture {
                            viewStore.send(.showShopDetail(shop.id))
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
}
