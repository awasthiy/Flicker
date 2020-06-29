//
//  ImageDetailViewController.swift
//  FlickerPhotoSearch
//
//  Created by Yash Awasthi on 25/06/2020.
//  Copyright © 2020 Yash Awasthi. All rights reserved.
//

import UIKit

final class ImageDetailViewController: BaseViewController {
    
    //MARK:- IBOUTLETS
    @IBOutlet fileprivate weak var imageView: UIImageView!
    
    //MARK:- Properties
    var viewModel : FlickerPhotoCellViewModel?
    
     //MARK:- View Controller's Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel?.title
        imageView.image = viewModel?.image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
     //MARK:- Private methods
    fileprivate func setUpUI() {
        guard let viewModel = viewModel else { return }
        guard let uRL = viewModel.detailURL else { return }
        DownloadImageService.shared.getImage(from: uRL, indexPath: nil) { (data, index, url) in
            guard let imageData = data else { return }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData)
            }
            
        }
    }
}
