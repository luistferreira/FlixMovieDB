import SwiftUI

@MainActor class HomeViewModel: ObservableObject {
    
    // MARK: - Types
    
    enum ViewModelState {
        case data, error, none
    }
    
    // MARK: - Published
    
    @Published var popularMoviesData = [Movie]()
    @Published var topMoviesData = [Movie]()
    @Published var upcomingMoviesData = [Movie]()
    @Published var top3Movies = [Movie]()
    @Published var topPostersPath = [String]()
    @Published var state: ViewModelState = .none
    @Published var hasReachedTheEnd: Bool = false
    @Published var segmentedControl: MovieListType = .popular
    @Published var segmentedControlList: [MovieListType] = [.popular, .upcoming, .topRated]
    
    // MARK: - Attributes
    
    private var topTop3Movies = [Movie]()
    private var popularTop3Movies = [Movie]()
    private var upcomingTop3Movies = [Movie]()
    private var popularPage: Int = 1
    private var topPage: Int = 1
    private var upcomingPage: Int = 1

    // MARK: - Methods

    func fetchMovieData(_ type: MovieListType) async {
        state = .none
        do {
            let fetchMovies = try await WebService().fetchData(PopularMovies.self,
                                                               listType: type,
                                                               page: popularPage)
            if let fetchMovies = fetchMovies,
               let results = fetchMovies.results {
                selectMovieDataList(type, results: results)
                incrementPageNumAndSetBackdrops(type: type, results: results)
            }
        } catch {
            state = .error
        }
    }
    
    func createBackdropPath(_ result: Movie) -> String {
        "https://image.tmdb.org/t/p/original" + (result.backdropPath ?? .empty)
    }
    
    func hasReachedTheEnd(_ result: Movie) -> Bool {
        popularMoviesData.last?.id == result.id
    }
    
    func switchTop3Movies() {
        switch segmentedControl {
        case .popular:
            top3Movies = popularTop3Movies
        case .upcoming:
            top3Movies = upcomingTop3Movies
        case .topRated:
            top3Movies = topTop3Movies
        }
    }
    
    // MARK: - Helpers

    private func selectMovieDataList(_ type: MovieListType, results: [Movie]) {
        switch type {
        case .popular:
            popularMoviesData.append(contentsOf: results)
        case .topRated:
            topMoviesData.append(contentsOf: results)
        case .upcoming:
            upcomingMoviesData.append(contentsOf: results)
        }
    }
    
    private func incrementPageNumAndSetBackdrops(type: MovieListType, results: [Movie]) {
        switch type {
        case .popular:
            if popularPage == 1 {
                popularTop3Movies = results
                while popularTop3Movies.count > 3 { popularTop3Movies.removeLast() }
                top3Movies = popularTop3Movies
            }
            popularPage += 1
            
        case .topRated:
            if topPage == 1 {
                topTop3Movies = results
                while topTop3Movies.count > 3 { topTop3Movies.removeLast() }
                top3Movies = topTop3Movies
            }
            topPage += 1
            
        case .upcoming:
            if upcomingPage == 1 {
                upcomingTop3Movies = results
                while upcomingTop3Movies.count > 3 { upcomingTop3Movies.removeLast() }
                top3Movies = upcomingTop3Movies
            }
            upcomingPage += 1
        }
    }
}
