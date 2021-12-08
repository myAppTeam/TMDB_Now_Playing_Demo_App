//
//  MovieDetailsViewController.swift
//  TMDB_Now_Playing_Demo_App
//
//  Created by Sachin Ambegave on 05/12/21.
//

import UIKit


class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var posterImageView: UIImageView!
    
    static let identifier = "MovieDetailsViewController"
    
    var selectedMovie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posterImageView.image = UIImage(named: "")
        [containerView, posterImageView].forEach({ _view in
            _view.layer.cornerRadius = 10
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showMoviePoster()
    }
    
    func showMoviePoster() {
        guard let movie = selectedMovie else { return }
        self.title = movie.title
        self.posterImageView.downloaded(from: movie.posterURL, contentMode: .scaleToFill)
    }
}
