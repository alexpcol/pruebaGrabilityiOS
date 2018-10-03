//
//  TopRatedTVSeriesViewController.swift
//  testRappi
//
//  Created by Mario on 10/2/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class TopRatedTVSeriesViewController: UIViewController {

    // MARK: - Variables
    var footerView:LoaderFooterView?
    var arrayOfTVSeries :[TVSerieData] = []
    private var currentPage = 1
    private var totalOfPages = 0
    var isLoading:Bool = false
    @IBOutlet weak var tvSeriesCollectionView: UICollectionView!
    
    
    // MARK: - LifecycleMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        if NetworkHelper.hasInternet() {
            getTopRatedTVSeries(page: currentPage, showActivity: true)
        }
        else
        {
            getTopRatedTVSeriesCache()
        }
    }
    
    func getTopRatedTVSeries(page: NSInteger, showActivity: Bool)
    {
        UIHelper.showActivityIndicator(in: self.view)
        let service = APIServices.init(delegate: self)
        service.getTopRatedTVSeries(language: nil, page: 1, region: nil)
    }
    
    func getTopRatedTVSeriesCache()
    {
        CacheGetter.getTopRatedTVSeries{ (tvSeriesData) in
            if let tvSeries = tvSeriesData?.tvSeries
            {
                self.arrayOfTVSeries = tvSeries
                self.tvSeriesCollectionView.reloadData()
            }
        }
    }
    
    func configure()
    {
        setUpCollectionsViews()
        setUpNavBar()
    }
    func setUpCollectionsViews()
    {
        tvSeriesCollectionView.register(UINib(nibName: NibNames.loaderFooterNib.rawValue, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CellsIdentifiers.refreshFooterView.rawValue)
        tvSeriesCollectionView.register(UINib(nibName: NibNames.movieNib.rawValue, bundle: nil), forCellWithReuseIdentifier: CellsIdentifiers.movieCollectionViewCell.rawValue)
    }
    func setUpNavBar()
    {
        let searchBar = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchBar
    }
}

extension TopRatedTVSeriesViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfTVSeries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        cell.titleLabel.text = arrayOfTVSeries[indexPath.row].name
        ImageService.getImage(withURL: URLS.secureImageBaseURL.rawValue + arrayOfTVSeries[indexPath.row].posterPath!) { (image) in
            cell.posterImageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let DetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        DetailViewController.titleString = arrayOfTVSeries[indexPath.row].name
        DetailViewController.dateString = arrayOfTVSeries[indexPath.row].firstAirDate
        DetailViewController.overviewString = arrayOfTVSeries[indexPath.row].overview
        ImageService.getImage(withURL: URLS.secureImageBaseURL.rawValue + arrayOfTVSeries[indexPath.row].posterPath!) { (image) in
            DetailViewController.posterImage = image
        }
        
        self.navigationController?.pushViewController(DetailViewController, animated: true)
    }
}

extension TopRatedTVSeriesViewController: UICollectionViewDelegateFlowLayout
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

extension TopRatedTVSeriesViewController: UIScrollViewDelegate
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
                    getTopRatedTVSeries(page: currentPage, showActivity: false)
                }
            }
        }
    }
}

extension TopRatedTVSeriesViewController: ResponseServicesProtocol
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
            let auxArrayOfTVSeries = DataTypeChanger.CreateArrayOfTVSeries(results: results)
            
            for auxItem in auxArrayOfTVSeries
            {
                self.arrayOfTVSeries.append(auxItem)
            }
            
            DispatchQueue.main.async {
                self.tvSeriesCollectionView.reloadData()
                UIHelper.turnOnAlphaWithAnimation(for: self.tvSeriesCollectionView)
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
