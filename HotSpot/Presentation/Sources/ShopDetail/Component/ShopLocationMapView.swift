import SwiftUI
import MapKit
import Domain

struct ShopLocationMapView: View {
    let shop: ShopModel

    var body: some View {
        let coordinate = CLLocationCoordinate2D(
            latitude: shop.latitude,
            longitude: shop.longitude
        )

        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )

        Map(coordinateRegion: .constant(region), annotationItems: [ShopPin(shop: shop)]) { pin in
            MapAnnotation(coordinate: pin.coordinate) {
                ZStack {
                    Circle()
                        .fill(Color(uiColor: pin.genre.color))
                        .frame(width: 40, height: 40)

                    Image(uiImage: pin.genre.image ?? UIImage())
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
            }
        }
        .frame(height: 300)
        .cornerRadius(8)
        .onTapGesture {
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = shop.name
            mapItem.openInMaps()
        }
    }
}

private struct ShopPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let genre: Genre

    init(shop: ShopModel) {
        self.coordinate = CLLocationCoordinate2D(latitude: shop.latitude, longitude: shop.longitude)
        self.genre = shop.genre
    }
}
