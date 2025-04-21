import UIKit
import MapKit

class ShopAnnotationView: MKMarkerAnnotationView {
    static let reuseIdentifier = "ShopAnnotationView"
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let shopAnnotation = newValue as? ShopAnnotation else { return }
            clusteringIdentifier = "Shop"
            canShowCallout = false
            isEnabled = true
            markerTintColor = ShopGenre.color(for: shopAnnotation.genreCode)
            if let originalImage = ShopGenre.image(for: shopAnnotation.genreCode) {
                glyphImage = originalImage.withTintColor(.white, renderingMode: .alwaysTemplate)
            }
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
} 
