import SwiftUI
import MapKit
import CoreLocation

struct MapRepresentableView: UIViewRepresentable {
    var shops: [ShopModel]
    var region: Binding<MapRegion>
    var onMarkerSelected: ((Int) -> Void)?

    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapRepresentableView
        private let locationManager = CLLocationManager()
        private var isFirstLocationUpdate = true

        init(parent: MapRepresentableView) {
            self.parent = parent
            super.init()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }

        func updateShops(_ newShops: [ShopModel]) {
            parent.shops = newShops
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last, isFirstLocationUpdate else { return }
            
            isFirstLocationUpdate = false
            let region = MapRegion(
                center: MapCoordinate(coordinate: location.coordinate),
                span: MapSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            
            DispatchQueue.main.async {
                self.parent.region.wrappedValue = region
            }
            
            locationManager.stopUpdatingLocation()
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            isFirstLocationUpdate = false
            let osakaCoordinate = MapCoordinate(latitude: 34.6937, longitude: 135.5023)
            let region = MapRegion(
                center: osakaCoordinate,
                span: MapSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            
            DispatchQueue.main.async {
                self.parent.region.wrappedValue = region
            }
            
            locationManager.stopUpdatingLocation()
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            DispatchQueue.main.async {
                self.parent.region.wrappedValue = MapRegion(region: mapView.region)
            }
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let cluster = annotation as? MKClusterAnnotation {
                return ShopClusterAnnotationView(annotation: cluster, reuseIdentifier: "cluster")
            }
            
            if let shopAnnotation = annotation as? ShopAnnotation {
                return ShopAnnotationView(annotation: shopAnnotation, reuseIdentifier: ShopAnnotationView.reuseIdentifier)
            }
            
            return nil
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let shopAnnotation = view.annotation as? ShopAnnotation {
                if let index = parent.shops.firstIndex(where: { $0.id == shopAnnotation.shopId }) {
                    parent.onMarkerSelected?(index)
                }
            }
            mapView.deselectAnnotation(view.annotation, animated: false)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.setRegion(region.wrappedValue.mkCoordinateRegion, animated: false)
        mapView.register(ShopAnnotationView.self, forAnnotationViewWithReuseIdentifier: ShopAnnotationView.reuseIdentifier)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        context.coordinator.updateShops(shops)
        
        uiView.removeAnnotations(uiView.annotations)

        let annotations = shops.map {
            ShopAnnotation(
                coordinate: $0.coordinate.clLocationCoordinate2D,
                title: $0.name,
                shopId: $0.id,
                genreCode: $0.genreCode
            )
        }

        uiView.addAnnotations(annotations)
        
        // Update map region if it has changed
        if uiView.region.center.latitude != region.wrappedValue.center.latitude ||
           uiView.region.center.longitude != region.wrappedValue.center.longitude {
            uiView.setRegion(region.wrappedValue.mkCoordinateRegion, animated: true)
        }
    }
}
