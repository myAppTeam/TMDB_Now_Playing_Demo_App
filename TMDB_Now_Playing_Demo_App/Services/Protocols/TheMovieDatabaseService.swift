//
//  TheMovieDatabaseService.swift
//  TMDB_Now_Playing_Demo_App
//
//  Created by Sachin Ambegave on 04/12/21.
//

import Foundation

protocol TheMovieDatabaseServiceProtocol: AnyObject {
    func fetchMovies(_ endPoint: Endpoint, params: [String: String]?, successHandler: @escaping (_ response: NowPlayingMovie) -> Void, errorHandler: @escaping (_ error: Error) -> Void)
}

public enum Endpoint: String {
    case nowPlaying = "now_playing"
    case trailer
    
}

public enum MovieError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
}
