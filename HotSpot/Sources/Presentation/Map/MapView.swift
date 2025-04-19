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
                        onRegionChanged: { lat, lng in
                            viewStore.send(.mapDidMove(lat: lat, lng: lng))
                        }
                    )
                    .ignoresSafeArea(.all, edges: .bottom)
                    .onAppear {
                        viewStore.send(.onAppear)
                    }

                    // 하단 카드 스크롤
                    SnappingScrollView(
                        items: viewStore.shops,
                        itemWidth: BaseSize.fullWidth
                    ) { shop in
                        ThumbnailTileView(
                            image: nil, // 이미지 URL 있으면 Kingfisher 등으로 연결
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
        }
    }
}
