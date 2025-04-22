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
                        Button {
                            onGenreSelected(genre.rawValue)
                        } label: {
                            Text(genre.name)
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedGenres.contains(genre.rawValue) ? Color.blue : Color(.systemGray6))
                                .foregroundColor(selectedGenres.contains(genre.rawValue) ? .white : .primary)
                                .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal, BaseSize.horizantalPadding)
            }
        }
    }
} 
