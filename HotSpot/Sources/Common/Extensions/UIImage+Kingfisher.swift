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
}
