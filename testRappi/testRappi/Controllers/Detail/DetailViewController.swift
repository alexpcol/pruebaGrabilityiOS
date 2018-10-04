//
//  DetailViewController.swift
//  testRappi
//
//  Created by chila on 10/2/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit
import AVKit

class DetailViewController: UIViewController {

    // MARK: - Variables
    var posterImage: UIImage?
    var titleString: String?
    var dateString: String?
    var overviewString: String?
    var id: NSInteger!
    @IBOutlet weak var posterBackgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var overViewTextView: UITextView!
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    func getMovieDetail()
    {
        UIHelper.showActivityIndicator(in: self.view)
        let service = APIServices.init(delegate: self)
        service.getMovieDetail(id: id, language: nil, appendToResponse: "videos")
    }
    // MARK: - Configure Methods
    func configure()
    {
        configureViews()
        addRightNavigationItem()
    }
    // MARK: - navigation items Methods
    func addRightNavigationItem()
    {
        let playTrailerButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playTrailer))
        self.navigationItem.rightBarButtonItem  = playTrailerButton
    }
    @objc func playTrailer()
    {
        getMovieDetail()
    }
    
    func pushNextView(video: VideoData)
    {
        let WebViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        WebViewController.videoKey = video.key
        self.navigationController?.pushViewController(WebViewController, animated: true)
    }
    // MARK: - ConfigureViews Methods
    func configureViews()
    {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        posterBackgroundImageView.image = posterImage
        posterImageView.image = posterImage
        titleLabel.text = titleString
        dateLabel.text = dateString
        overViewTextView.text = overviewString
        self.view.bringSubviewToFront(overViewTextView)
        UIHelper.roundCorners(for: posterImageView)
    }
}

extension DetailViewController: ResponseServicesProtocol
{
    func onSucces(Result: String, name: ServicesNames) {
        print("success")
        let resultDic = DataTypeChanger.JSONDataToDiccionary(text: Result)
        if let videos = resultDic?["videos"] as? [String : Any]
        {
            if let results = videos["results"] as? [[String :Any]]
            {
                let auxArrayVideos = DataTypeChanger.CreateArrayOfVideos(results: results)
                let video = VideoData.init(id: auxArrayVideos[0].id, key: auxArrayVideos[0].key, site: auxArrayVideos[0].site)
                DispatchQueue.main.async {
                    self.pushNextView(video: video)
                }
                
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
