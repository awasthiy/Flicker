//
//  BaseViewController.swift
//  FlickerPhotoSearch
//
//  Created by Yash Awasthi on 26/06/2020.
//  Copyright © 2020 Yash Awasthi. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.backgroundColor = NaiveDarkAndLightMode.current().background
    }
}

extension BaseViewController {
    internal func showLoading() {
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        strLabel = UILabel(frame: CGRect(x: 50,
                                         y: 0,
                                         width: 160,
                                         height: 46))
        strLabel.text = Constants.kLoading
        strLabel.font = UIFont.systemFont(ofSize: 14,
                                          weight: UIFont.Weight.medium)
        strLabel.textColor = UIColor(white: 0.9,
                                     alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2,
                                  y: view.frame.midY - strLabel.frame.height/2 ,
                                  width: 160,
                                  height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .white
        activityIndicator.frame = CGRect(x: 0,
                                         y: 0,
                                         width: 46,
                                         height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        DispatchQueue.main.async {
            self.view.addSubview(self.effectView)
        }
    }
    
    internal func hideLoading() {
        DispatchQueue.main.async {
            self.effectView.removeFromSuperview()
        }
    }
}
extension BaseViewController {
    func showAlert(with title: String, and message : String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .cancel,
                                      handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
