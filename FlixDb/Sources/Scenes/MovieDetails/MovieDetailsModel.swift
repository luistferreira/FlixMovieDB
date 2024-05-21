// MARK: - MoviesImage

struct MoviesImage: Codable {
    let backdrops: [Backdrop]
    let id: Int
}

// MARK: - Backdrop

struct Backdrop: Codable {
    let filePath: String?

    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}

struct MovieDetailsModel: Codable {
    let id: Int
    let cast: [Cast]
}

// MARK: - Cast

struct Cast: Codable {
    let id: Int
    let name: String?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case profilePath = "profile_path"
    }
}
