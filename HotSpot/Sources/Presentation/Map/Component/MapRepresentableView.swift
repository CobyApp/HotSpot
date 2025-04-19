import SwiftUI
import MapKit

// MARK: - Custom Annotation

class ShopAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?

    init(coordinate: CLLocationCoordinate2D, title: String?) {
        self.coordinate = coordinate
        self.title = title
    }
}

// MARK: - Custom Annotation View

class ShopAnnotationView: MKAnnotationView {
    static let reuseIdentifier = "ShopAnnotationView"

    private var iconImageView: UIImageView?

    override var annotation: MKAnnotation? {
        willSet {
            guard newValue is ShopAnnotation else { return }
            canShowCallout = true
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        let size: CGFloat = 40
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
        backgroundView.backgroundColor = UIColor.black
        backgroundView.layer.cornerRadius = size / 2
        backgroundView.layer.borderColor = UIColor.gray.cgColor
        backgroundView.layer.borderWidth = 1

        let iconImageView = UIImageView(frame: CGRect(x: 8, y: 8, width: 24, height: 24))
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit

        backgroundView.addSubview(iconImageView)
        addSubview(backgroundView)
        self.iconImageView = iconImageView
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        subviews.first?.center = CGPoint(x: bounds.midX, y: bounds.midY)
        iconImageView?.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}

// MARK: - UIViewRepresentable Map

struct MapRepresentableView: UIViewRepresentable {
    var shops: [ShopModel]
    var onRegionChanged: ((Double, Double) -> Void)?

    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapRepresentableView
        var locationManager: CLLocationManager?
        var mapView: MKMapView?

        init(parent: MapRepresentableView) {
            self.parent = parent
            super.init()
            setupLocationManager()
        }

        private func setupLocationManager() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.requestWhenInUseAuthorization()
        }

        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                print("📍 Location authorized")
                manager.startUpdatingLocation()
            case .denied, .restricted:
                print("⚠️ Location access denied")
            case .notDetermined:
                print("❓ Location access not determined")
            @unknown default:
                break
            }
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            let region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            mapView?.setRegion(region, animated: true)
            manager.stopUpdatingLocation()
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            let center = mapView.region.center
            print("🗺️ Map region changed to: lat=\(center.latitude), lng=\(center.longitude)")
            parent.onRegionChanged?(center.latitude, center.longitude)
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? ShopAnnotation else { return nil }

            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: ShopAnnotationView.reuseIdentifier) as? ShopAnnotationView {
                view.annotation = annotation
                return view
            } else {
                return ShopAnnotationView(annotation: annotation, reuseIdentifier: ShopAnnotationView.reuseIdentifier)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        context.coordinator.mapView = mapView
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)

        let annotations: [ShopAnnotation] = shops.map {
            ShopAnnotation(
                coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude),
                title: $0.name
            )
        }

        uiView.addAnnotations(annotations)
    }
}
