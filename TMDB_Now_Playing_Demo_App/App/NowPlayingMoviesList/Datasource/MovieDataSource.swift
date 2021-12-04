//
//  MovieDataSource.swift
//  TMDB_Now_Playing_Demo_App
//
//  Created by Sachin Ambegave on 04/12/21.
//

import Foundation
import UIKit

class GenericDataSource<T> : NSObject {
    var data: Box<[T]> = Box([])
}

class MovieDataSource: GenericDataSource<Movie>, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = data.value[indexPath.item]
        if movie.voteAveragePercentage < 7 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UnpopularMovieCell.reuseIdentifier, for: indexPath) as! UnpopularMovieCell
            cell.configure(movie: movie)
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularMovieCell.reuseIdentifier, for: indexPath) as! PopularMovieCell
            cell.configure(movie: movie)
            return cell
        }
    }
}
