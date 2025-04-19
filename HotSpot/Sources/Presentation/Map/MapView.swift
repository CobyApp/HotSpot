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
                        shops: viewStore.shops,
                        centerCoordinate: viewStore.binding(
                            get: { ($0.centerLat, $0.centerLng) },
                            send: { .updateCoordinates(lat: $0.0, lng: $0.1) }
                        ),
                        onRegionChanged: { region in
                            viewStore.send(.updateCoordinates(lat: region.center.latitude, lng: region.center.longitude))
                            updateRangeIfNeeded(region: region, viewStore: viewStore)
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

        UIImage.loadThumbnail(from: shop.imageUrl) { image in
            DispatchQueue.main.async {
                shopImages[shop.id] = image
            }
        }
    }

    private func updateRangeIfNeeded(region: MKCoordinateRegion, viewStore: ViewStore<MapStore.State, MapStore.Action>) {
        // Calculate the approximate distance in meters based on the visible region
        let span = region.span
        let center = region.center
        
        // Calculate the distance in meters (approximate)
        let latDistance = span.latitudeDelta * 111000 // 1 degree of latitude is approximately 111km
        let lngDistance = span.longitudeDelta * 111000 * cos(center.latitude * .pi / 180)
        let maxDistance = max(latDistance, lngDistance)
        
        // Determine the appropriate range based on the distance
        let newRange: Int
        if maxDistance <= 300 {
            newRange = 1
        } else if maxDistance <= 500 {
            newRange = 2
        } else if maxDistance <= 1000 {
            newRange = 3
        } else if maxDistance <= 2000 {
            newRange = 4
        } else {
            newRange = 5
        }
        
        // Only update if the range has changed
        if viewStore.currentRange != newRange {
            viewStore.send(.updateRange(newRange))
        }
    }
}
