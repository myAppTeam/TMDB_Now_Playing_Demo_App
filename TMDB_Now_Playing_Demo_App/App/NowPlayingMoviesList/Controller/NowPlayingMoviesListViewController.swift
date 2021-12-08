//
//  NowPlayingMoviesListViewController.swift
//  TMDB_Now_Playing_Demo_App
//
//  Created by Sachin Ambegave on 04/12/21.
//

import UIKit

class NowPlayingMoviesListViewController: UIViewController {
    static let identifier = "NowPlayingMoviesListViewController"
    @IBOutlet weak private var collectionView: UICollectionView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredMovies: [Movie] = []
    
    
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
        addSearchController()
        registerCells()
        self.collectionView.dataSource = self.datasource
        self.collectionView.delegate = self
        
        setupCollectionViewListLayout()
        
        self.datasource.data.addAndNotify(observer: self) { [weak self] in
            if let data = self?.datasource.data, data.isDeletedRow {
                if let index = data.deletedRowIndex {
                    self?.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                    data.isDeletedRow = false
                    data.deletedRowIndex = nil
                }
            }else {
                self?.collectionView.reloadData()
            }
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
    
    private func setupCollectionViewListLayout() {
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
    }
    
    private func addSearchController() {
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search artists"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    private func fetchMovies() {
        self.viewModel.fetchNowPlayingMovies()
    }
    
    private func registerCells() {
        self.collectionView.register(UINib(nibName: PopularMovieCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PopularMovieCell.reuseIdentifier)
        self.collectionView.register(UINib(nibName: UnpopularMovieCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: UnpopularMovieCell.reuseIdentifier)
    }
}


extension NowPlayingMoviesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = (searchController.searchBar.text ?? "")
        print("Searching with: " + searchText)
        guard searchText.count > 0 else {
            self.datasource.data.filteredValue = self.datasource.data.value
            return
        }
        let filteredMovies = self.datasource.data.value
        self.datasource.data.filteredValue = filteredMovies.filter({ $0.title.contains(searchText) })
    }
}

extension NowPlayingMoviesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = self.datasource.data.filteredValue[indexPath.item]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyboard.instantiateViewController(withIdentifier: MovieDetailsViewController.identifier) as! MovieDetailsViewController

        self.datasource.data.selectedMovie = movie
        detailsViewController.selectedMovie = self.datasource.data.selectedMovie
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
