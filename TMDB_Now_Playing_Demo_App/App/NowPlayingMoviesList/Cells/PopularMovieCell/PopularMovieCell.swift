//
//  PopularMovieCell.swift
//  TMDB_Now_Playing_Demo_App
//
//  Created by Sachin Ambegave on 04/12/21.
//

import UIKit

class PopularMovieCell: UICollectionViewCell {

    static let reuseIdentifier = "PopularMovieCell"
    @IBOutlet weak private var posterImageView: UIImageView!
    @IBOutlet weak private var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [containerView, posterImageView].forEach({ _view in
            _view.layer.cornerRadius = 10
        })
    }
    
    func configure(movie: Movie) {
        self.posterImageView.downloaded(from: movie.backdropURL, contentMode: .scaleToFill)
    }
}
