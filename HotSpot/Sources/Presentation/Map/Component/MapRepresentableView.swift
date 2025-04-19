import SwiftUI
import MapKit

struct MapRepresentableView: UIViewRepresentable {
    var shops: [ShopModel]
    var centerCoordinate: Binding<(Double, Double)>
    var onRegionChanged: (MKCoordinateRegion) -> Void

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapRepresentableView

        init(parent: MapRepresentableView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let region = mapView.region
            DispatchQueue.main.async {
                self.parent.onRegionChanged(region)
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
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.register(ShopAnnotationView.self, forAnnotationViewWithReuseIdentifier: ShopAnnotationView.reuseIdentifier)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)

        let annotations = shops.map {
            ShopAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude),
                title: $0.name,
                shopId: $0.id,
                genreCode: $0.genreCode
            )
        }

        uiView.addAnnotations(annotations)
    }
}
