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
                        restaurants: .constant(viewStore.restaurants),
                        topLeft: .constant(viewStore.topLeft),
                        bottomRight: .constant(viewStore.bottomRight)
                    )
                    .ignoresSafeArea(.all, edges: .bottom)
                    
//                    ScrollView(.horizontal) {
//                        LazyHStack(spacing: 8) {
//                            ForEach(.store.filteredMemories) { restaurant in
//                                ThumbnailTileView(
//                                    image: memory.photos.first,
//                                    title: memory.title,
//                                    subTitle: memory.date.formatShort,
//                                    description: memory.note
//                                )
//                                .frame(width: BaseSize.fullWidth, height: 120)
//                                .onTapGesture {
//                                    store.send(.showDetailMemory(memory))
//                                }
//                                .containerRelativeFrame(.horizontal)
//                            }
//                        }
//                        .scrollTargetLayout()
//                    }
//                    .contentMargins(.horizontal, BaseSize.horizantalPadding, for: .scrollContent)
//                    .scrollIndicators(.hidden)
//                    .scrollTargetBehavior(.viewAligned)
//                    .frame(height: 120)
//                    .padding(.bottom, 30)
                }
            }
        }
    }
}
