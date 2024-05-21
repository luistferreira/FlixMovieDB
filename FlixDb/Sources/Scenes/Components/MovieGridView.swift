import SwiftUI

struct MovieGridView: View {
    
    // MARK: - Attributes
    
    @Binding var movieData: [Movie]
    var performFetch: () -> Void
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - View
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
            ForEach(movieData, id: \.id) { movie in
                NavigationLink(destination: MovieDetailsView(viewModel: MovieDetailsViewModel(movieData: movie))) {
                    MoviePosterView(title: movie.title ?? .empty,
                                    imageLink: createPosterPath(movie))
                    .onAppear {
                        if movieData.last?.id == movie.id {
                            performFetch()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Methods

extension MovieGridView {
    
    func createPosterPath(_ result: Movie) -> String {
        "https://image.tmdb.org/t/p/w500" + (result.posterPath ?? .empty)
    }
}

// MARK: - Preview

#Preview {
    MovieGridView(movieData: .constant([]), performFetch: { })
}
