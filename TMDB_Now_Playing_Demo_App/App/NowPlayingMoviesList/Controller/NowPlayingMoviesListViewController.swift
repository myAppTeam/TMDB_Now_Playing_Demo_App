//
//  NowPlayingMoviesListViewController.swift
//  TMDB_Now_Playing_Demo_App
//
//  Created by Sachin Ambegave on 04/12/21.
//

import UIKit

class NowPlayingMoviesListViewController: UIViewController {
    
    @IBOutlet weak private var collectionView: UICollectionView!
    
    let datasource = MovieDataSource()
    
    lazy var viewModel: NowPlayingMoviesViewModel = {
        let viewModel = NowPlayingMoviesViewModel(datasource: datasource)
        return viewModel
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    
    fileprivate func setup() {
        self.title = "Now Playing Movies"
        
        registerCells()
        self.collectionView.dataSource = self.datasource
        
        let spacing = 16.0
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: (spacing / 2), left: spacing, bottom: (spacing / 2), right: spacing)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let paddingSpace = layout.sectionInset.left + layout.sectionInset.right
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth - layout.minimumLineSpacing - layout.minimumInteritemSpacing
        
        layout.itemSize = CGSize(width: widthPerItem, height: 250)
        self.collectionView.collectionViewLayout = layout
//        DispatchQueue.main.async {
//            self.collectionView.layoutIfNeeded()
//        }
        self.datasource.data.addAndNotify(observer: self) { [weak self] in
            self?.collectionView.reloadData()
        }
        
        self.viewModel.onErrorHandling = { [unowned self] _ in
            // display error
            let title = "An error occurred"
            let message = "Oops, something went wrong!"
            
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            controller.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                self.fetchMovies()
            }))
            self.present(controller, animated: true, completion: nil)
        }
        fetchMovies()
    }
    
    private func fetchMovies() {
        self.viewModel.fetchNowPlayingMovies()
    }
    
    private func registerCells() {
        self.collectionView.register(UINib(nibName: PopularMovieCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PopularMovieCell.reuseIdentifier)
        self.collectionView.register(UINib(nibName: UnpopularMovieCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: UnpopularMovieCell.reuseIdentifier)
        
        
    }
}
