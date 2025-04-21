import SwiftUI

struct GenreSection: View {
    let selectedGenreCode: String
    let onGenreSelected: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ジャンル")
                .font(.system(size: 16, weight: .bold))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Genre.allCases, id: \.rawValue) { genre in
                        Button {
                            onGenreSelected(genre.rawValue)
                        } label: {
                            Text(genre.name)
                                .font(.system(size: 14))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedGenreCode == genre.rawValue ? Color.blue : Color.gray.opacity(0.1))
                                .foregroundColor(selectedGenreCode == genre.rawValue ? .white : .black)
                                .cornerRadius(16)
                        }
                    }
                }
            }
        }
    }
} 
