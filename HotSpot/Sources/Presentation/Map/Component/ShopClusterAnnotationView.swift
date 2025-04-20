import UIKit
import MapKit

class ShopClusterAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        didSet {
            guard let cluster = annotation as? MKClusterAnnotation else { return }
            displayPriority = .defaultHigh
            
            let rect = CGRect(x: 0, y: 0, width: 40, height: 40)
            image = UIGraphicsImageRenderer.image(for: cluster.memberAnnotations, in: rect)
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension UIGraphicsImageRenderer {
    static func image(for annotations: [MKAnnotation], in rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        
        let totalCount = annotations.count
        let countText = "\(totalCount)"
        
        return renderer.image { _ in
            UIColor.black.setFill()
            UIBezierPath(ovalIn: rect).fill()
            
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()
            
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.black,
                .font: UIFont.boldSystemFont(ofSize: 14)
            ]
            
            let textSize = countText.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (rect.width - textSize.width) / 2,
                y: (rect.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            
            countText.draw(in: textRect, withAttributes: attributes)
        }
    }
} 