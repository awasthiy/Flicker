//
//  FlickerPhotoCell.swift
//  FlickerPhotoSearch
//
//  Created by Yash Awasthi on 19/06/20.
//  Copyright © 2020 Yash Awasthi. All rights reserved.
//

import UIKit

final class FlickerPhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel : FlickerPhotoCellViewModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = #imageLiteral(resourceName: "placeHolder")
    }
    
    func fillUI(indexPath : IndexPath) {
        guard let viewModel = viewModel else { return }
        guard let url = viewModel.mediumURL else { return }
        DownloadImageService.shared.getImage(from: url, indexPath: indexPath) { (data, index, key) in
            guard let imageData = data else { return }
            guard let _ = index else { return }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData)
                self.viewModel?.inflateValues(index: index?.row, image: self.imageView.image)
            }
        }
    }
}

