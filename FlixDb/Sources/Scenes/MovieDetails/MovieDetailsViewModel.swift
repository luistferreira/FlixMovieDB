import SwiftUI

@MainActor class MovieDetailsViewModel: ObservableObject {
    
    // MARK: - Types
    
    enum ViewModelState {
        case data, error, none
    }
    
    // MARK: - Published
    
    @Published var movieData: Movie
    @Published var state: ViewModelState = .none
    @Published var movieDetails: MovieDetailsModel?
    @Published var movieImages: [Backdrop] = []
    
    init(movieData: Movie) {
        self.movieData = movieData
    }
    
    // MARK: - Methods

    func fetchMovieData() async {
        state = .none
        do {
            guard let id = movieData.id else { return }
            let fetchMovies = try await WebService().fetchDataCredits(MovieDetailsModel.self, movieID: id)
            let fetchImages = try await WebService().fetchDataImages(MoviesImage.self, movieID: id)
            
            movieDetails = fetchMovies
            if let backdrops = fetchImages?.backdrops {
                movieImages = backdrops
            }
            state = .data
        } catch {
            state = .error
        }
    }

    func createBackdropPath(_ result: Movie) -> String {
        "https://image.tmdb.org/t/p/original" + (result.backdropPath ?? .empty)
    }
    
    func createCastPath(_ cast: Cast) -> String {
        "https://image.tmdb.org/t/p/w500" + (cast.profilePath ?? .empty)
    }
    
    func createBackdrops(_ backdrop: Backdrop) -> String {
        "https://image.tmdb.org/t/p/w500" + (backdrop.filePath ?? .empty)
    }
}
