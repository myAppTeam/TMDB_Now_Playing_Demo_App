//
//  NowPlayingMoviesViewModel.swift
//  TMDB_Now_Playing_Demo_App
//
//  Created by Sachin Ambegave on 04/12/21.
//

import Foundation
import UIKit

struct NowPlayingMoviesViewModel {
    weak var datasource: GenericDataSource<Movie>?
    weak var theMovieDBService: TheMovieDatabaseServiceProtocol?
    var onErrorHandling : ((MovieError?) -> Void)?
    
    init(service: TheMovieDatabaseServiceProtocol = TheMovieDatabaseStore.shared, datasource: GenericDataSource<Movie>) {
        self.datasource = datasource
        self.theMovieDBService = service
    }
    
    func fetchNowPlayingMovies() {
        guard let theMovieDBService = theMovieDBService else {
            self.onErrorHandling?(MovieError.invalidEndpoint)
            return
        }

        theMovieDBService.fetchMovies(.nowPlaying, params: [:], successHandler: { response in
            self.datasource?.data.filteredValue = response.results
            self.datasource?.data.value = response.results
        }, errorHandler: { error in
            self.onErrorHandling?(error as? MovieError)
        })
    }
}
