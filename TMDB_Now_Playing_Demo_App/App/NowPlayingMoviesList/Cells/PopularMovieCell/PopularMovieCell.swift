//
//  PopularMovieCell.swift
//  TMDB_Now_Playing_Demo_App
//
//  Created by Sachin Ambegave on 04/12/21.
//

import UIKit

class PopularMovieCell: BaseCollectionViewCell {

    static let reuseIdentifier = "PopularMovieCell"
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak private var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.image = UIImage(named: "")
        [containerView, posterImageView].forEach({ _view in
            _view.layer.cornerRadius = 10
        })
    }
    
    func configure(movie: Movie) {
//        _ = ImageCache(url: movie.backdropURL)
        self.posterImageView.downloaded(from: movie.backdropURL, contentMode: .scaleToFill)
    }
}
