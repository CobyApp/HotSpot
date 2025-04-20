import UIKit
import Kingfisher

extension UIImage {
    static func load(from urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                completion(value.image)
            case .failure:
                completion(nil)
            }
        }
    }
    
    static func loadThumbnail(from urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))
        KingfisherManager.shared.retrieveImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        ) { result in
            switch result {
            case .success(let value):
                completion(value.image)
            case .failure:
                completion(nil)
            }
        }
    }
}
