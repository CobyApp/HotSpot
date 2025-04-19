import SwiftUI
import CobyDS

struct SnappingScrollView<Content: View, Item: Identifiable>: View {
    let items: [Item]
    let itemWidth: CGFloat
    let spacing: CGFloat
    let content: (Item) -> Content
    
    @State private var scrollOffset: CGFloat = 0
    
    init(
        items: [Item],
        itemWidth: CGFloat,
        spacing: CGFloat = 8,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.itemWidth = itemWidth
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(items) { item in
                        content(item)
                            .id(item.id)
                    }
                }
                .padding(.horizontal, BaseSize.horizantalPadding)
                .background(
                    GeometryReader { geometry in
                        Color.clear.preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: geometry.frame(in: .named("scroll")).minX
                        )
                    }
                )
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                scrollOffset = offset
            }
            .gesture(
                DragGesture()
                    .onEnded { _ in
                        let totalWidth = itemWidth + spacing
                        let currentIndex = Int(round(scrollOffset / totalWidth))
                        let adjustedIndex = max(0, min(currentIndex, items.count - 1))
                        
                        withAnimation(.easeOut(duration: 0.2)) {
                            proxy.scrollTo(items[adjustedIndex].id, anchor: .center)
                        }
                    }
            )
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
} 
