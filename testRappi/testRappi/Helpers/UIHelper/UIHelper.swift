//
//  UIHelper.swift
//  testRappi
//
//  Created by Mario on 10/2/18.
//  Copyright © 2018 chila. All rights reserved.
//

import UIKit

class UIHelper: NSObject {
    
    static func makeCardViewWithShadow(for view: UIView) {
        view.layer.cornerRadius = 14
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowRadius = 10
    }
    static func roundCorners(for view: UIView) {
        view.layer.cornerRadius = 14
    }
    
    static func turnOnAlphaWithAnimation(for view: UIView) {
        let animator = UIViewPropertyAnimator(duration: 0.8, curve: .easeIn) {
            view.alpha = 1
        }
        
        animator.startAnimation()
    }
    
    static func turnOffAlphaWithAnimation(for view: UIView) {
        let animator = UIViewPropertyAnimator(duration: 0.8, curve: .easeIn) {
            view.alpha = 0
        }
        animator.startAnimation()
    }
    
    static func showActivityIndicator(in view: UIView) {
        view.isUserInteractionEnabled = false
        let activityView = UIActivityIndicatorView(style: .gray)
        activityView.tag = 777
        activityView.center = view.center
        activityView.startAnimating()
        view.addSubview(activityView)
        view.bringSubviewToFront(activityView)
    }
    
    static func dismissActivityIndicator(in view: UIView) {
        for subView : UIView in view.subviews {
            if subView.tag == 777 {
                subView.removeFromSuperview()
                view.isUserInteractionEnabled = true
            }
        }
    }
    static func setLargeTitles(in viewController: UIViewController) {
        viewController.navigationController?.navigationBar.prefersLargeTitles = true
    }
}
