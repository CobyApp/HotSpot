import SwiftUI

import CobyDS
import ComposableArchitecture

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
                        restaurants: viewStore.binding(
                            get: { $0.restaurants },
                            send: { _ in .getRestaurants }
                        ),
                        topLeft: viewStore.binding(
                            get: { $0.topLeft },
                            send: { .updateTopLeft($0) }
                        ),
                        bottomRight: viewStore.binding(
                            get: { $0.bottomRight },
                            send: { .updateBottomRight($0) }
                        )
                    )
                    .ignoresSafeArea(.all, edges: .bottom)
                    .onAppear {
                        print("MapView appeared")
                        viewStore.send(.onAppear)
                    }

                    SnappingScrollView(
                        items: viewStore.restaurants,
                        itemWidth: BaseSize.fullWidth
                    ) { restaurant in
                        ThumbnailTileView(
                            image: nil,
                            title: restaurant.name,
                            subTitle: "",
                            description: restaurant.address
                        )
                        .frame(width: BaseSize.fullWidth, height: 120)
                        .onTapGesture {
                            viewStore.send(.showRestaurantDetail(restaurant.id))
                        }
                    }
                    .frame(height: 120)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}
