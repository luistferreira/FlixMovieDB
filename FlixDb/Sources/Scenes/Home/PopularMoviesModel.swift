// MARK: - PopularMovies

enum MovieListType: String {
    case popular
    case topRated = "top_rated"
    case upcoming
    
    var title: String {
        switch self {
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        case .upcoming:
            return "Upcoming"
        }
    }
}

struct PopularMovies: Codable {
    let page: Int?
    let results: [Movie]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result

struct Movie: Codable {
    var backdropPath: String?
    let id: Int?
    let posterPath: String?
    let title: String?
    
    init(backdropPath: String? = nil, id: Int? = nil, posterPath: String? = nil, title: String? = nil) {
        self.backdropPath = backdropPath
        self.id = id
        self.posterPath = posterPath
        self.title = title
    }
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case posterPath = "poster_path"
        case title
    }
}
