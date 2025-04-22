import UIKit
import MapKit
import Domain

class ShopAnnotationView: MKMarkerAnnotationView {
    static let reuseIdentifier = "ShopAnnotationView"
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let shopAnnotation = newValue as? ShopAnnotation else { return }
            clusteringIdentifier = "Shop"
            canShowCallout = false
            isEnabled = true
            
            if let genre = Genre.from(code: shopAnnotation.genreCode) {
                markerTintColor = genre.color
                if let originalImage = genre.image {
                    glyphImage = originalImage.withTintColor(.white, renderingMode: .alwaysTemplate)
                }
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
