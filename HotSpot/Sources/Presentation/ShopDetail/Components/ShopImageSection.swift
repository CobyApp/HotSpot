import SwiftUI
import Kingfisher
import CobyDS

struct ShopImageSection: View {
    let imageUrl: String
    
    var body: some View {
        Group {
            if let url = URL(string: imageUrl) {
                KFImage(url)
                    .placeholder {
                        Image(uiImage: UIImage.icImage)
                            .resizable()
                            .frame(width: 64, height: 64)
                            .foregroundColor(Color.labelAlternative)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.fillStrong)
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: BaseSize.screenWidth, height: BaseSize.screenWidth)
                    .clipped()
            } else {
                Image(uiImage: UIImage.icImage)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .foregroundColor(Color.labelAlternative)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.fillStrong)
                    .frame(width: BaseSize.screenWidth, height: BaseSize.screenWidth)
            }
        }
    }
}

#Preview {
    ShopImageSection(imageUrl: "https://example.com/image.jpg")
} 