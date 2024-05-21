import Foundation

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}

class WebService {
    
    func fetchData<T: Codable>(_ type: T.Type, listType: MovieListType, page: Int) async throws -> T? {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(listType.rawValue)"),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw NetworkError.badUrl
        }
        
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "\(page)"),
        ]
        
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        guard let componentsUrl = components.url else { throw NetworkError.badUrl }
        
        let request = createRequest(url: componentsUrl)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
        guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.badResponse
        }
    }
    
    func fetchDataCredits<T: Codable>(_ type: T.Type, movieID: Int) async throws -> T? {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/credits"),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw NetworkError.badUrl
        }
        
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
        ]
        
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        guard let componentsUrl = components.url else { throw NetworkError.badUrl }

        let request = createRequest(url: componentsUrl)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
        guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }

        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.badResponse
        }
    }
        
    func fetchDataImages<T: Codable>(_ type: T.Type, movieID: Int) async throws -> T? {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/images"),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let componentsURL = components.url else {
            throw NetworkError.badUrl
        }
        
        let request = createRequest(url: componentsURL)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
        guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }

        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.badResponse
        }
    }
    
    func createRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyZTVlMzhkZTQ4N2Y2Nzk0N2M1ZWExMGQ1OTBlODA3YyIsInN1YiI6IjYyM2UxZWVkZTM4YmQ4MDA1YzBmMzIyZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.l4AI3jFrsVXe5XpBA5Heem1zCP7egXkdnlZqhInyYow"
        ]
        return request
    }
}
