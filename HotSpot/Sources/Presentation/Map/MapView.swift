import SwiftUI
import MapKit
import ComposableArchitecture
import CobyDS
import Kingfisher

struct MapView: View {
    let store: StoreOf<MapStore>
    @State private var shopImages: [String: UIImage] = [:]
    @Environment(\.coordinator) private var coordinator

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                TopBarView(
                    leftSide: .title,
                    leftTitle: "HotSpot",
                    rightSide: .icon,
                    rightIcon: UIImage.icSearch,
                    rightAction: {
                        coordinator?.showSearch()
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

                    if !viewStore.visibleShops.isEmpty {
                        CarouselScrollViewRepresentable(
                            items: viewStore.visibleShops,
                            itemWidth: BaseSize.fullWidth,
                            spacing: 8
                        ) { shop in
                            ThumbnailTileView(
                                image: shopImages[shop.id],
                                title: shop.name,
                                subTitle: nil,
                                description: shop.access,
                                subDescription: nil
                            )
                            .onTapGesture {
                                coordinator?.showShopDetail(shop)
                            }
                            .onAppear {
                                loadImage(for: shop)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 120)
                        .padding(.bottom, 30)
                    }
                }
            }
            .onChange(of: viewStore.error) { error in
                if let error = error {
                    coordinator?.showError(error)
                    viewStore.send(.clearError)
                }
            }
            .onChange(of: viewStore.visibleShops) { shops in
                if shops.isEmpty {
                    coordinator?.showMessage(
                        title: "お店が見つかりません",
                        message: "ズームインして再度お試しください"
                    )
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
