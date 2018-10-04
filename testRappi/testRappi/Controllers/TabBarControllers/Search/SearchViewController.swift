//
//  SearchViewController.swift
//  testRappi
//
//  Created by Mario on 10/4/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Variables
    var footerView:LoaderFooterView?
    var arrayOfItems :[SearchItem] = []
    private var currentPage = 1
    private var totalOfPages = 0
    var isLoading:Bool = false
    var shouldClearArray: Bool = false
    var searchController: UISearchController!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    @IBOutlet weak var searchPlaceHolderView: UIView!
    
    // MARK: - Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // Do any additional setup after loading the view.
    }
    
    // MARK:- Requests Methods
    func searchItem(text: String, showActivity: Bool)
    {
        shouldClearArray = true
        if showActivity{ UIHelper.showActivityIndicator(in: self.view) }
        let service = APIServices.init(delegate: self)
        service.getSearchItem(language: nil, page: 1, region: nil, query: text)
    }
    func getMoreSearchItems(page: NSInteger, text: String)
    {
        shouldClearArray = false
        let service = APIServices.init(delegate: self)
        service.getSearchItem(language: nil, page: page, region: nil, query: text)
    }
    
    // MARK:- Configuration Methods
    func configure()
    {
        setUpCollectionsViews()
        setUpNavBar()
    }
    func setUpCollectionsViews()
    {
        itemsCollectionView.register(UINib(nibName: NibNames.loaderFooterNib.rawValue, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CellsIdentifiers.refreshFooterView.rawValue)
        itemsCollectionView.register(UINib(nibName: NibNames.movieNib.rawValue, bundle: nil), forCellWithReuseIdentifier: CellsIdentifiers.movieCollectionViewCell.rawValue)
    }
    func setUpNavBar()
    {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchPlaceHolderView.addSubview(searchController.searchBar)
        itemsCollectionView.contentInsetAdjustmentBehavior = .automatic
        definesPresentationContext = true
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate
{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            if !searchText.isEmpty{
                self.searchItem(text: searchText, showActivity: true)
            }
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        cell.titleLabel.text = arrayOfItems[indexPath.row].title
        cell.posterImageView.getImage(withURL: URLS.secureImageBaseURL.rawValue + arrayOfItems[indexPath.row].posterPath!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MovieCollectionViewCell
        let DetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        DetailViewController.titleString = arrayOfItems[indexPath.row].title
        DetailViewController.dateString = arrayOfItems[indexPath.row].date
        DetailViewController.overviewString = arrayOfItems[indexPath.row].overview
        DetailViewController.posterImage = cell.posterImageView.image
        //DetailViewController.isMovie = true
        self.navigationController?.pushViewController(DetailViewController, animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout
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
extension SearchViewController: UIScrollViewDelegate
{
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
                    if let searchText = searchController.searchBar.text{
                        if !searchText.isEmpty{
                            self.getMoreSearchItems(page: currentPage, text: searchText)
                        }
                    }
                    
                }
            }
        }
    }
}

extension SearchViewController: ResponseServicesProtocol
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
            let auxArrayOfSearch = DataTypeChanger.CreateArrayOfSearch(results: results)
            
            if shouldClearArray
            {
                self.arrayOfItems.removeAll()
            }
            
            for auxItem in auxArrayOfSearch
            {
                self.arrayOfItems.append(auxItem)
            }
            
            DispatchQueue.main.async {
                self.itemsCollectionView.reloadData()
                UIHelper.turnOnAlphaWithAnimation(for: self.itemsCollectionView)
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
