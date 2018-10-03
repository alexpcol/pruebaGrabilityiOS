//
//  PopularTVSeriesViewController.swift
//  testRappi
//
//  Created by chila on 10/2/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class PopularTVSeriesViewController: UIViewController {

    // MARK: - Variables
    var arrayOfTVSeries :[TVSerieData] = []
    private var currentPage = 1
    private var totalOfPages = 0
    @IBOutlet weak var tvSeriesCollectionView: UICollectionView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getPopularTVSeries(page: currentPage)
    }
    
    
    // MARK:- Requests Methods
    func getPopularTVSeries(page: NSInteger)
    {
        UIHelper.showActivityIndicator(in: self.view)
        let service = APIServices.init(delegate: self)
        service.getPopularTVSeries(language: nil, page: page, region: nil)
    }
    
    // MARK:- Configuration Methods
    func configure()
    {
        setUpCollectionsViews()
        setUpNavBar()
    }
    func setUpCollectionsViews()
    {
        tvSeriesCollectionView.register(UINib(nibName: NibNames.movieNib.rawValue, bundle: nil), forCellWithReuseIdentifier: CellsIdentifiers.movieCollectionViewCell.rawValue)
    }
    func setUpNavBar()
    {
        let searchBar = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchBar
    }
}

extension PopularTVSeriesViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arrayOfTVSeries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == arrayOfTVSeries.count - 1
        {
            if currentPage < totalOfPages
            {
                currentPage += 1
                getPopularTVSeries(page: currentPage)
            }
        }
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


extension PopularTVSeriesViewController: ResponseServicesProtocol
{
    func onSucces(Result: String, name: ServicesNames) {
        print("success")
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
        var messagage = ""
        let resultDic = DataTypeChanger.JSONDataToDiccionary(text: Error)
        if let errors: [String] = resultDic?["errors"] as? [String]
        {
            messagage = errors[0]
        }
        else
        {
            messagage = resultDic?["status_message"] as! String
        }
        DispatchQueue.main.async {
            UIHelper.dismissActivityIndicator(in: self.view)
            AlertsPresenter.showOKAlert(title: "Error", andMessage: messagage, inView: self)
        }
    }
}