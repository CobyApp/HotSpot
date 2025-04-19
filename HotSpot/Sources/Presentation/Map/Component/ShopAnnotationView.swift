import UIKit
import MapKit

class ShopAnnotationView: MKMarkerAnnotationView {
    static let reuseIdentifier = "ShopAnnotationView"
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let shopAnnotation = newValue as? ShopAnnotation else { return }
            clusteringIdentifier = "Shop"
            canShowCallout = false
            isEnabled = false
            markerTintColor = ShopGenreColor.color(for: shopAnnotation.genreCode)
            glyphImage = ShopGenreColor.image(for: shopAnnotation.genreCode)
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
        frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
    }
} 