//
//  TopRatedMoviesViewController.swift
//  testRappi
//
//  Created by Mario on 10/2/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class TopRatedMoviesViewController: UIViewController {

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
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        if NetworkHelper.hasInternet() {
            getTopRatedMovies(page: currentPage, showActivity: true)
        }
        else
        {
            getTopRatedMoviesCache()
        }
    }
     // MARK: - Request methods
    func getTopRatedMovies(page: NSInteger, showActivity: Bool)
    {
        if showActivity{ UIHelper.showActivityIndicator(in: self.view) }
        let service = APIServices.init(delegate: self)
        service.getTopRatedMovies(language: nil, page: page, region: nil)
    }
    
    func getTopRatedMoviesCache()
    {
        CacheGetter.getTopRatedMovies{ (moviesData) in
            if let movies = moviesData?.movies
            {
                self.arrayOfMovies = movies
                self.moviesCollectionView.reloadData()
            }
        }
    }
    // MARK: - configurations methods
    func configure()
    {
        setUpCollectionsViews()
        setUpNavBar()
    }
    func setUpCollectionsViews()
    {
        moviesCollectionView.register(UINib(nibName: NibNames.loaderFooterNib.rawValue, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CellsIdentifiers.refreshFooterView.rawValue)
        moviesCollectionView.register(UINib(nibName: NibNames.movieNib.rawValue, bundle: nil), forCellWithReuseIdentifier: CellsIdentifiers.movieCollectionViewCell.rawValue)
    }
    func setUpNavBar()
    {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchPlaceHolderView.addSubview(searchController.searchBar)
        moviesCollectionView.contentInsetAdjustmentBehavior = .automatic
        definesPresentationContext = true
    }

}

extension TopRatedMoviesViewController: UISearchResultsUpdating, UISearchBarDelegate
{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filteredArrayOfMovies = searchText.isEmpty ? arrayOfMovies : arrayOfMovies.filter({($0.title?.localizedCaseInsensitiveContains(searchText))!})
            
            moviesCollectionView.reloadData()
        }
    }
    
}

extension TopRatedMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredArrayOfMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        cell.titleLabel.text = filteredArrayOfMovies[indexPath.row].title
        cell.posterImageView.getImage(withURL: URLS.secureImageBaseURL.rawValue + filteredArrayOfMovies[indexPath.row].posterPath!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MovieCollectionViewCell
        let DetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        DetailViewController.titleString = filteredArrayOfMovies[indexPath.row].title
        DetailViewController.dateString = filteredArrayOfMovies[indexPath.row].releaseDate
        DetailViewController.overviewString = filteredArrayOfMovies[indexPath.row].overview
        DetailViewController.id = filteredArrayOfMovies[indexPath.row].id
        DetailViewController.posterImage = cell.posterImageView.image
        
        self.navigationController?.pushViewController(DetailViewController, animated: true)
    }
}

extension TopRatedMoviesViewController: UICollectionViewDelegateFlowLayout
{
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

extension TopRatedMoviesViewController: UIScrollViewDelegate
{
    //compute the scroll value and play witht the threshold to get desired effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 100.0 ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(abs(triggerThreshold),1.0);
        self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            self.footerView?.animateFinal()
        }
    }
    
    //compute the offset and call the load method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = abs(diffHeight - frameHeight);
        if pullHeight == 0.0
        {
            if (self.footerView?.isAnimatingFinal)! {
                print("load more trigger")
                self.isLoading = true
                self.footerView?.startAnimate()
                if currentPage < totalOfPages
                {
                    currentPage += 1
                    getTopRatedMovies(page: currentPage, showActivity: false)
                }
            }
        }
    }
}

extension TopRatedMoviesViewController: ResponseServicesProtocol
{
    func onSucces(Result: String, name: ServicesNames) {
        print("success")
        self.isLoading = false
        let resultDic = DataTypeChanger.JSONDataToDiccionary(text: Result)
        if let pages = resultDic?["total_pages"] as? NSInteger{
            self.totalOfPages = pages
        }
        if let results = resultDic?["results"] as? [[String : Any]]
        {
            let auxArrayOfMovies = DataTypeChanger.CreateArrayOfMovies(results: results)
            
            for auxItem in auxArrayOfMovies
            {
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
        if let errors: [String] = resultDic?["errors"] as? [String]
        {
            messagage = errors[0]
        }
        else
        {
            if let statusMessagage: String = resultDic?["status_message"] as? String
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
            AlertsPresenter.showOKAlert(title: "Error", andMessage: messagage, inView: self)
        }
    }
}
