//
//  UpcomingViewController.swift
//  testRappi
//
//  Created by chila on 10/2/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    
    // MARK: - Variables
    var arrayOfMovies :[MovieData] = []
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getUpcomingMovies()
    }
    
    
    // MARK:- Requests Methods
    func getUpcomingMovies()
    {
        UIHelper.showActivityIndicator(in: self.view)
        let service = APIServices.init(delegate: self)
        service.getUpcomingMovies(language: nil, page: 1, region: nil)
    }
    
    // MARK:- Configuration Methods
    func configure()
    {
        setUpCollectionsViews()
        setUpNavBar()
    }
    func setUpCollectionsViews()
    {
        moviesCollectionView.register(UINib(nibName: NibNames.movieNib.rawValue, bundle: nil), forCellWithReuseIdentifier: CellsIdentifiers.movieCollectionViewCell.rawValue)
    }
    func setUpNavBar()
    {
        let searchBar = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchBar
    }
}

extension UpcomingViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        cell.titleLabel.text = arrayOfMovies[indexPath.row].title
        ImageService.getImage(withURL: URLS.secureImageBaseURL.rawValue + arrayOfMovies[indexPath.row].posterPath!) { (image) in
            cell.posterImageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let DetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        DetailViewController.titleString = arrayOfMovies[indexPath.row].title
        DetailViewController.dateString = arrayOfMovies[indexPath.row].releaseDate
        DetailViewController.overviewString = arrayOfMovies[indexPath.row].overview
        ImageService.getImage(withURL: URLS.secureImageBaseURL.rawValue + arrayOfMovies[indexPath.row].posterPath!) { (image) in
            DetailViewController.posterImage = image
        }
        
        self.navigationController?.pushViewController(DetailViewController, animated: true)
    }
}

extension UpcomingViewController: ResponseServicesProtocol
{
    func onSucces(Result: String, name: ServicesNames) {
        print("success")
        let resultDic = DataTypeChanger.JSONDataToDiccionary(text: Result)
        if let results = resultDic?["results"] as? [[String : Any]]
        {
            self.arrayOfMovies = DataTypeChanger.CreateArrayOfMovies(results: results)
            
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
