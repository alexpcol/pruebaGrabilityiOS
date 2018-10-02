//
//  ViewController.swift
//  testRappi
//
//  Created by chila on 10/1/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class PopularViewController: UIViewController {

    // MARK:- Variables
    var arrayOfMovies :[MovieData] = []
    var arrayOfTVSeries: [TVSerieData] = []
    @IBOutlet weak var moviesColllectionView: UICollectionView!
    
    @IBOutlet weak var tvSeriesCollectionView: UICollectionView!
    
    // MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getPopularMovies()
    }
    
    // MARK:- Requests Methods
    func getPopularMovies()
    {
        UIHelper.showActivityIndicator(in: self.view)
        let service = APIServices.init(delegate: self)
        service.getPopularMovies(language: nil, page: 1, region: nil)
    }
    
    // MARK:- Configuration Methods
    func configure()
    {
        setUpCollectionsViews()
        setUpNavBar()
    }
    func setUpCollectionsViews()
    {
        moviesColllectionView.register(UINib(nibName: NibNames.movieNib.rawValue, bundle: nil), forCellWithReuseIdentifier: CellsIdentifiers.movieCollectionViewCell.rawValue)
        // It's the same config becase It's the same item
        tvSeriesCollectionView.register(UINib(nibName: NibNames.movieNib.rawValue, bundle: nil), forCellWithReuseIdentifier: CellsIdentifiers.movieCollectionViewCell.rawValue)
    }
    func setUpNavBar()
    {
        let searchBar = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchBar
        
    }

}


extension PopularViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == moviesColllectionView
        {
            return arrayOfMovies.count
        }
        else
        {
            return arrayOfTVSeries.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        cell.titleLabel.text = arrayOfMovies[indexPath.row].title
        ImageService.getImage(withURL: URLS.secureImageBaseURL.rawValue + arrayOfMovies[indexPath.row].posterPath!) { (image) in
            cell.posterImageView.image = image
        }
        return cell
    }


}

extension PopularViewController: ResponseServicesProtocol
{
    func onSucces(Result: String, name: ServicesNames) {
        print("success")
        let resultDic = DataTypeChanger.JSONDataToDiccionary(text: Result)
        if let results = resultDic?["results"] as? [[String : Any]]
        {
            self.arrayOfMovies = DataTypeChanger.CreateArrayOfMovies(results: results)
            
            DispatchQueue.main.async {
                self.moviesColllectionView.reloadData()
                UIHelper.turnOnAlphaWithAnimation(for: self.moviesColllectionView)
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

