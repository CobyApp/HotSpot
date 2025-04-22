import SwiftUI
import CobyDS

struct GenreSection: View {
    let selectedGenres: [String]
    let onGenreSelected: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ジャンル")
                .font(.pretendard(size: 16, weight: .semibold))
                .foregroundColor(Color.labelNormal)
                .padding(.horizontal, BaseSize.horizantalPadding)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Genre.allCases, id: \.self) { genre in
                        FilterButton(
                            title: genre.name,
                            isSelected: selectedGenres.contains(genre.rawValue),
                            action: { onGenreSelected(genre.rawValue) }
                        )
                    }
                }
                .padding(.horizontal, BaseSize.horizantalPadding)
            }
        }
    }
} 
