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
    var arrayOfMovies :[MovieData] = []
    private var currentPage = 1
    private var totalOfPages = 0
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getTopRatedMovies(page: currentPage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("Volvimos movieees")
    }
    
    func getTopRatedMovies(page: NSInteger)
    {
        UIHelper.showActivityIndicator(in: self.view)
        let service = APIServices.init(delegate: self)
        service.getTopRatedMovies(language: nil, page: 1, region: nil)
    }
    
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

extension TopRatedMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == arrayOfMovies.count - 1
        {
            if currentPage < totalOfPages
            {
                currentPage += 1
                getTopRatedMovies(page: currentPage)
            }
        }
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

extension TopRatedMoviesViewController: ResponseServicesProtocol
{
    func onSucces(Result: String, name: ServicesNames) {
        print("success")
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
