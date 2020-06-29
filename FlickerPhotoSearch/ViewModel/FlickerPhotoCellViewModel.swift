//
//  FlickerPhotoCellViewModel.swift
//  FlickerPhotoSearch
//
//  Created by Yash Awasthi on 28/06/20.
//  Copyright © 2020 Yash awasthi. All rights reserved.
//

import UIKit

protocol FlickerPhotoCellViewModelProtocol : class {
    var image : UIImage? { get set }
    var title : String? { get set }
    var mediumURL : URL? { get set }
    var detailURL : URL? { get set }
}

class FlickerPhotoCellViewModel : NSObject, FlickerPhotoCellViewModelProtocol{
    var image : UIImage?
    var title : String?
    var mediumURL : URL?
    var detailURL : URL?
    
    override init() {
        super.init()
    }
    
    public func initializeValueWith(photo : Photo) {
        self.title = photo.title
        self.mediumURL = photo.imageUrl()
        self.detailURL = photo.imageUrl(Constants.imageSizeL)
    }
    
    public func inflateValues(index : Int?, image : UIImage?) {
        self.image = image
    }
}
