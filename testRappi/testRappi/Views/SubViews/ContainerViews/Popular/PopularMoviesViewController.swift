//
//  PopularMoviesViewController.swift
//  testRappi
//
//  Created by chila on 10/2/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class PopularMoviesViewController: UIViewController {

    
    // MARK: - Variables
    var footerView:LoaderFooterView?
    var arrayOfMovies :[MovieData] = []
    var filteredArrayOfMovies : [MovieData] = []
    private var currentPage = 1
    private var totalOfPages = 0
    var isLoading:Bool = false
    var searchController: UISearchController!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var searchPlaceHolderView: UIView!
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        if NetworkHelper.hasInternet() {
            getPopularMovies(page: currentPage, showActivity: true)
        }
        else {
            getPopularMoviesCache()
        }
        
    }
    
    // MARK:- Requests Methods
    func getPopularMovies(page: NSInteger, showActivity: Bool) {
        if showActivity{ UIHelper.showActivityIndicator(in: self.view) }
        let service = APIServices.init(delegate: self)
        service.getPopularMovies(language: nil, page: page, region: nil)
    }
    
    func getPopularMoviesCache() {
        CacheGetter.getPopularMovies { (moviesData) in
            if let movies = moviesData?.movies {
                self.arrayOfMovies = movies
                self.moviesCollectionView.reloadData()
            }
        }
    }
    
    // MARK:- Configuration Methods
    func configure() {
        setUpCollectionsViews()
        setUpNavBar()
    }
    func setUpCollectionsViews() {
        moviesCollectionView.register(UINib(nibName: NibNames.loaderFooterNib.rawValue, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CellsIdentifiers.refreshFooterView.rawValue)
        moviesCollectionView.register(UINib(nibName: NibNames.movieNib.rawValue, bundle: nil), forCellWithReuseIdentifier: CellsIdentifiers.movieCollectionViewCell.rawValue)
    }
    func setUpNavBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchPlaceHolderView.addSubview(searchController.searchBar)
        moviesCollectionView.contentInsetAdjustmentBehavior = .automatic
        definesPresentationContext = true
    }

}

extension PopularMoviesViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredArrayOfMovies = searchText.isEmpty ? arrayOfMovies : arrayOfMovies.filter({($0.title?.localizedCaseInsensitiveContains(searchText))!})
            
            moviesCollectionView.reloadData()
        }
    }
}


extension PopularMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredArrayOfMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellsIdentifiers.movieCollectionViewCell.rawValue, for: indexPath) as! MovieCollectionViewCell
        
        cell.titleLabel.text = filteredArrayOfMovies[indexPath.row].title
        DispatchQueue.main.async {
            cell.posterImageView.getImage(withURL: URLS.secureImageBaseURL.rawValue + self.filteredArrayOfMovies[indexPath.row].posterPath!)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! MovieCollectionViewCell
        
        let DetailViewController = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifiers.detailVC.rawValue) as! DetailViewController
        
        DetailViewController.titleString = filteredArrayOfMovies[indexPath.row].title
        DetailViewController.dateString = filteredArrayOfMovies[indexPath.row].releaseDate
        DetailViewController.overviewString = filteredArrayOfMovies[indexPath.row].overview
        DetailViewController.id = filteredArrayOfMovies[indexPath.row].id
        DetailViewController.posterImage = cell.posterImageView.image
        DetailViewController.isMovie = true

        self.navigationController?.pushViewController(DetailViewController, animated: true)
    }
}

extension PopularMoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellsIdentifiers.refreshFooterView.rawValue, for: indexPath) as! LoaderFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellsIdentifiers.refreshFooterView.rawValue, for: indexPath)
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.prepareInitialAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.stopAnimate()
        }
    }
}

extension PopularMoviesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pointToReach   = 150.0 ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var reachedThePoint  = Float((diffHeight - frameHeight))/Float(pointToReach);
        reachedThePoint   =  min(reachedThePoint, 0.0)
        let pullRatio  = min(abs(reachedThePoint),1.0);
        self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            self.footerView?.animateFinal()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = abs(diffHeight - frameHeight);
        if pullHeight == 0.0
        {
            if (self.footerView?.isAnimatingFinal)!
            {
                print("load more trigger")
                self.isLoading = true
                self.footerView?.startAnimate()
                if currentPage < totalOfPages
                {
                    currentPage += 1
                    getPopularMovies(page: currentPage, showActivity: false)
                }
            }
        }
    }
}

extension PopularMoviesViewController: ResponseServicesProtocol {
    func onSucces(Result: String, name: ServicesNames) {
        print("success")
        self.isLoading = false
        let resultDic = DataTypeChanger.JSONDataToDiccionary(text: Result)
        if let pages = resultDic?[ServicesFieldsKeys.totalPages.rawValue] as? NSInteger{
            self.totalOfPages = pages
        }
        if let results = resultDic?[ServicesFieldsKeys.results.rawValue] as? [[String : Any]]
        {
            let auxArrayOfMovies = DataTypeChanger.CreateArrayOfMovies(results: results)
           
            for auxItem in auxArrayOfMovies
            {
                self.arrayOfMovies.append(auxItem)
            }
            
            self.filteredArrayOfMovies = self.arrayOfMovies
            
            CacheSaver.savePopularMovies(movies: self.arrayOfMovies)
    
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
        if let errors: [String] = resultDic?[ServicesFieldsKeys.errors.rawValue] as? [String]
        {
            messagage = errors[0]
        }
        else
        {
            if let statusMessagage: String = resultDic?[ServicesFieldsKeys.statusMessage.rawValue] as? String
            {
                messagage = statusMessagage
            }
            else
            {
                messagage = Error
            }
        }
        DispatchQueue.main.async {
            UIHelper.dismissActivityIndicator(in: self.view)
            AlertsPresenter.showOKAlert(title: messagesTitle.error.rawValue, andMessage: messagage, inView: self)
        }
    }
}
