import SwiftUI
import MapKit

struct ShopLocationMapView: View {
    let shop: ShopModel
    
    var body: some View {
        GeometryReader { geometry in
            let coordinate = CLLocationCoordinate2D(
                latitude: shop.latitude,
                longitude: shop.longitude
            )
            
            let region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.01,
                    longitudeDelta: 0.01
                )
            )
            
            Map(
                coordinateRegion: .constant(region),
                interactionModes: []
            )
            .frame(height: 200)
            .cornerRadius(8)
            .overlay(
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color(uiColor: ShopGenre.color(for: shop.genreCode)))
            )
            .onTapGesture {
                let placemark = MKPlacemark(coordinate: coordinate)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = shop.name
                mapItem.openInMaps()
            }
        }
        .frame(height: 200)
    }
}

#Preview {
    ShopLocationMapView(
        shop: ShopModel(
            id: "test",
            name: "テスト店舗",
            address: "東京都渋谷区",
            latitude: 35.6762,
            longitude: 139.6503,
            imageUrl: "https://example.com/image.jpg",
            access: "渋谷駅から徒歩5分",
            openingHours: "11:00-23:00",
            genreCode: "G001"
        )
    )
} 