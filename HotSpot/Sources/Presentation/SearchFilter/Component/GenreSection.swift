import SwiftUI

struct GenreSection: View {
    let selectedGenres: [String]
    let onGenreSelected: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ジャンル")
                .font(.system(size: 17, weight: .semibold))
                .padding(.horizontal, 16)
            
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
                .padding(.horizontal, 16)
            }
        }
    }
} 
