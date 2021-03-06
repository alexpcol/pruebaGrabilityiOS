//
//  Upcoming2ViewController.swift
//  testRappi
//
//  Created by Mauricio Conde on 4/15/19.
//  Copyright © 2019 chila. All rights reserved.
//

import UIKit
import Nuke

class Upcoming2ViewController: UIViewController {
    
    // MARK: - Variables
    var footerView:LoaderFooterView?
    var arrayOfMovies :[MovieData] = []
    var filteredArrayOfMovies : [MovieData] = []
    private var currentPage = 1
    private var totalOfPages = 0
    var isLoading:Bool = false
    var searchController: UISearchController!
    let preheater = ImagePreheater()
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        if NetworkHelper.hasInternet() {
            getUpcomingMovies(page: currentPage, showActivity: true)
        }
        else {
            getUpcomingMoviesCache()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIHelper.setLargeTitles(in: self)
    }
    
    // MARK:- Requests Methods
    func getUpcomingMovies(page: NSInteger, showActivity: Bool) {
        if showActivity{ UIHelper.showActivityIndicator(in: self.view) }
        let service = APIServices.init(delegate: self)
        service.getUpcomingMovies(language: nil, page: page, region: nil)
    }
    
    func getUpcomingMoviesCache() {
        CacheGetter.getUpcomingMovies{ (moviesData) in
            if let movies = moviesData?.movies {
                self.arrayOfMovies = movies
                self.moviesCollectionView.reloadData()
            }
        }
    }
    
    // MARK:- Configuration Methods
    func configure() {
        moviesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if #available(iOS 10.0, *) {
            moviesCollectionView?.isPrefetchingEnabled = true
            moviesCollectionView?.prefetchDataSource = self
        }
        setUpCollectionsViews()
        setUpNavBar()
    }
    func setUpCollectionsViews() {
        moviesCollectionView.register(UINib(nibName: NibNames.loaderFooterNib.rawValue, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CellsIdentifiers.refreshFooterView.rawValue)
        moviesCollectionView.register(UINib(nibName: NibNames.movieNib.rawValue, bundle: nil), forCellWithReuseIdentifier: CellsIdentifiers.movieCollectionViewCell.rawValue)
    }
    func setUpNavBar() {
        UIHelper.setLargeTitles(in: self)
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        moviesCollectionView.contentInsetAdjustmentBehavior = .automatic
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
}

extension Upcoming2ViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filteredArrayOfMovies = searchText.isEmpty ? arrayOfMovies : arrayOfMovies.filter({($0.title?.localizedCaseInsensitiveContains(searchText))!})
            
            moviesCollectionView.reloadData()
        }
    }
}

extension Upcoming2ViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredArrayOfMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == filteredArrayOfMovies.count - 1 {
            if currentPage < totalOfPages {
                currentPage += 1
                getUpcomingMovies(page: currentPage, showActivity: false)
            }
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellsIdentifiers.movieCollectionViewCell.rawValue, for: indexPath) as! MovieCollectionViewCell
        let movie = filteredArrayOfMovies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MovieCollectionViewCell
        let DetailViewController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.detailVC.rawValue) as! DetailViewController
        
        DetailViewController.titleString = filteredArrayOfMovies[indexPath.row].title
        DetailViewController.dateString = filteredArrayOfMovies[indexPath.row].releaseDate
        DetailViewController.overviewString = filteredArrayOfMovies[indexPath.row].overview
        DetailViewController.posterImage = cell.posterImageView.image
        DetailViewController.id = filteredArrayOfMovies[indexPath.row].id
        DetailViewController.isMovie = true
        self.navigationController?.pushViewController(DetailViewController, animated: true)
    }
}



extension Upcoming2ViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.map { return URL(string: URLS.secureImageBaseURL.rawValue + filteredArrayOfMovies[$0.row].posterPath!)!}
        preheater.startPreheating(with: urls)
        print("prefetch")
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.map { return URL(string: URLS.secureImageBaseURL.rawValue + filteredArrayOfMovies[$0.row].posterPath!)! }
        preheater.stopPreheating(with: urls)
        print("cancel")
    }
}

extension Upcoming2ViewController: ResponseServicesProtocol
{
    func onSucces(Result: String, name: ServicesNames) {
        print("success")
        self.isLoading = false
        let resultDic = DataTypeChanger.JSONDataToDiccionary(text: Result)
        if let pages = resultDic?[ServicesFieldsKeys.totalPages.rawValue] as? NSInteger{
            self.totalOfPages = pages
        }
        if let results = resultDic?[ServicesFieldsKeys.results.rawValue] as? [[String : Any]] {
            let auxArrayOfMovies = DataTypeChanger.CreateArrayOfMovies(results: results)
            
            for auxItem in auxArrayOfMovies {
                self.arrayOfMovies.append(auxItem)
            }
            
            self.filteredArrayOfMovies = self.arrayOfMovies
            
            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
                UIHelper.turnOnAlphaWithAnimation(for: self.moviesCollectionView)
            }
        }
        
        
        DispatchQueue.main.async {
            UIHelper.dismissActivityIndicator(in: self.view)
        }
    }
    
    func onError(Error: String, name: ServicesNames) {
        print("Error")
        self.isLoading = false
        var messagage = ""
        let resultDic = DataTypeChanger.JSONDataToDiccionary(text: Error)
        if let errors: [String] = resultDic?[ServicesFieldsKeys.errors.rawValue] as? [String] {
            messagage = errors[0]
        }
        else {
            if let statusMessagage: String = resultDic?[ServicesFieldsKeys.statusMessage.rawValue] as? String {
                messagage = statusMessagage
            }
            else {
                messagage = Error
            }
        }
        DispatchQueue.main.async {
            UIHelper.dismissActivityIndicator(in: self.view)
            AlertsPresenter.showOKAlert(title: messagesTitle.error.rawValue, andMessage: messagage, inView: self)
        }
    }
}

