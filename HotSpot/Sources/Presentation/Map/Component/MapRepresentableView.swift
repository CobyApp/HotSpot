import SwiftUI
import MapKit

import CobyDS

// Custom Annotation Class
class RestaurantAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?) {
        self.coordinate = coordinate
        self.title = title
    }
}

// Custom Annotation View Class
class RestaurantAnnotationView: MKAnnotationView {
    static let reuseIdentifier = "RestaurantAnnotationView"
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let restaurantAnnotation = newValue as? RestaurantAnnotation else { return }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
    }
    
    private var iconImageView: UIImageView?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        // Circle background
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        backgroundView.backgroundColor = UIColor(Color.staticBlack)
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.masksToBounds = true
        
        // Add border to backgroundView
        backgroundView.layer.borderColor = UIColor(Color.lineNormalNormal).cgColor
        backgroundView.layer.borderWidth = 1.0
        
        // White icon
        let iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor(Color.staticWhite)
        
        backgroundView.addSubview(iconImageView)
        addSubview(backgroundView)
        
        self.iconImageView = iconImageView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subviews.first?.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        iconImageView?.center = CGPoint(x: 20, y: 20) // Center the icon within the circle
    }
}

struct MapRepresentableView: UIViewRepresentable {
    
    @Binding var restaurants: [Restaurant]
    @Binding var topLeft: Location?
    @Binding var bottomRight: Location?
    
    init(
        restaurants: Binding<[Restaurant]>,
        topLeft: Binding<Location?>,
        bottomRight: Binding<Location?>
    ) {
        self._restaurants = restaurants
        self._topLeft = topLeft
        self._bottomRight = bottomRight
    }
    
    class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var parent: MapRepresentableView
        var mapView: MKMapView?
        
        init(parent: MapRepresentableView) {
            self.parent = parent
            super.init()
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            self.parent.topLeft = mapView.convert(CGPoint(x: 0, y: 0), toCoordinateFrom: mapView).toLocation()
            self.parent.bottomRight = mapView.convert(CGPoint(x: mapView.frame.width, y: mapView.frame.height), toCoordinateFrom: mapView).toLocation()
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? RestaurantAnnotation else { return nil }
            
            let annotationView: RestaurantAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: RestaurantAnnotationView.reuseIdentifier) as? RestaurantAnnotationView {
                dequeuedView.annotation = annotation
                annotationView = dequeuedView
            } else {
                annotationView = RestaurantAnnotationView(annotation: annotation, reuseIdentifier: RestaurantAnnotationView.reuseIdentifier)
                annotationView.annotation = annotation
            }
            return annotationView
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        context.coordinator.mapView = mapView
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        print("MapRepresentableView updateUIView called")
        print("Restaurants count: \(self.restaurants.count)")
        self.addMarkersToMapView(uiView)
        
        // Set initial region if needed
        if uiView.annotations.isEmpty {
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )
            uiView.setRegion(region, animated: true)
        }
    }
    
    private func addMarkersToMapView(_ mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        
        print("Adding markers for \(self.restaurants.count) restaurants")
        let annotations = self.restaurants.compactMap { restaurant -> RestaurantAnnotation? in
            guard let coordinate = restaurant.location?.toCLLocationCoordinate2D() else { return nil }
            return RestaurantAnnotation(
                coordinate: coordinate,
                title: restaurant.name
            )
        }
        print("Created \(annotations.count) annotations")
        
        mapView.addAnnotations(annotations)
    }
}
