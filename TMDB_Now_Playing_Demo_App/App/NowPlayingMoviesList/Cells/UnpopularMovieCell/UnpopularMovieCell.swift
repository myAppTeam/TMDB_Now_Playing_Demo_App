//
//  UnpopularMovieCell.swift
//  TMDB_Now_Playing_Demo_App
//
//  Created by Sachin Ambegave on 04/12/21.
//

import UIKit

class UnpopularMovieCell: BaseCollectionViewCell {

    static let reuseIdentifier = "UnpopularMovieCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var overviewLabel: UILabel!
    @IBOutlet weak private var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.image = UIImage(named: "")
        [containerView, posterImageView].forEach({ _view in
            _view.layer.cornerRadius = 10
        })
    }

    func configure(movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
//        _ = ImageCache(url: movie.posterURL)
        self.posterImageView.downloaded(from: movie.posterURL, contentMode: .scaleToFill)
    }
}
