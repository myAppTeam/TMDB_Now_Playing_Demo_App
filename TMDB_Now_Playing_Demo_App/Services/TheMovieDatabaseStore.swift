//
//  TheMovieDatabaseStore.swift
//  TMDB_Now_Playing_Demo_App
//
//  Created by Sachin Ambegave on 04/12/21.
//

import Foundation

final class TheMovieDatabaseStore: TheMovieDatabaseServiceProtocol {
    
    static let shared = TheMovieDatabaseStore()
    private let apiKey = "XXXXXXXXXX"
    private let baseURL = "https://api.themoviedb.org/3/movie/"
    private let urlSession = URLSession.shared
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    
    func fetchMovies(_ endPoint: Endpoint, params: [String : String]?, successHandler: @escaping (NowPlayingMovie) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard var urlComponents = URLComponents(string: "\(baseURL)\(endPoint.rawValue)") else {
            errorHandler(MovieError.invalidEndpoint)
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        if let params = params {
            queryItems.append(contentsOf: params.map
                                            { URLQueryItem(name: $0.key, value: $0.value) }
                             )
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            errorHandler(MovieError.invalidEndpoint)
            return
        }
        
        urlSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.handleError(errorHandler: errorHandler, error: MovieError.apiError)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<299 ~= httpResponse.statusCode else {
                self.handleError(errorHandler: errorHandler, error: MovieError.invalidResponse)
                return
            }
            
            guard let data = data else {
                self.handleError(errorHandler: errorHandler, error: MovieError.noData)
                return
            }
            
            do {
                let nowPlayingMovies = try self.jsonDecoder.decode(NowPlayingMovie.self, from: data)
                DispatchQueue.main.async {
                    successHandler(nowPlayingMovies)
                }
            }catch {
                self.handleError(errorHandler: errorHandler, error: MovieError.serializationError)
            }
        }.resume()
    }
    
    private func handleError(errorHandler: @escaping (_ error: Error) -> Void, error: Error) {
        DispatchQueue.main.async {
            errorHandler(error)
        }
    }
}
