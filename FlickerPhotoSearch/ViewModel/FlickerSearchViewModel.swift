//
//  FlickerSearchViewModel.swift
//  FlickerPhotoSearch
//
//  Created by Yash Awasthi on 28/06/20.
//  Copyright © 2020 Yash awasthi. All rights reserved.
//

import Foundation


enum FetchingState {
    case newKeyword
    case newPage
}

typealias EmptyBlock = ()->()
typealias BoolBlock = (Bool)->()

protocol FlickerSearchViewModelProtocol {
    var cellViewModels : [FlickerPhotoCellViewModel] { get set }
    var searchStr : String { get set }
    var showAlertOnError : (EmptyBlock)? { get set }
    var showLoader : (BoolBlock)? { get set }
    var reloadCollectionView : (EmptyBlock)? { get set }
    var numberOfItems : Int { get }
    var updatedPagingState : (BoolBlock)? { get set }
    var networkService : DataService { get set }
    
    func getCellViewModel(indexPath : IndexPath) -> FlickerPhotoCellViewModel?
    func cleanup()
    func viewDidEndDisplay(index : Int)
    func fetchData()
    func fetchData(fetchingState : FetchingState)
}

class FlickerSearchViewModel : NSObject, FlickerSearchViewModelProtocol{
    
    private var photos: [Photo] = []
    private var pageNum: Int = 1
    var searchStr : String = ""
    public var showAlertOnError : (EmptyBlock)?
    public var showLoader : (BoolBlock)?
    public var reloadCollectionView : (EmptyBlock)?
    public var updatedPagingState : (BoolBlock)?
    
    var cellViewModels : [FlickerPhotoCellViewModel] = []
    
    var networkService : DataService = NetworkManager()
    

    override init() {
        super.init()
    }
    
    var numberOfItems : Int {
        return self.cellViewModels.count
    }
    
    public func getCellViewModel(indexPath : IndexPath) -> FlickerPhotoCellViewModel? {
        return self.cellViewModels[safe: indexPath.row]
    }
    
    public func fetchData() {
        self.fetchData(fetchingState : .newKeyword)
    }
    
    public func fetchData(fetchingState : FetchingState) {
        if searchStr == "" { return }
        
        if fetchingState == .newPage {
            pageNum += 1
        } else {
            //showLoader
            self.showLoader?(true)
        }
        networkService.getPhotosData(for: self.searchStr,
                                            with: pageNum) { (photos, error) in
                                                //hideLoader
                                                if fetchingState == .newKeyword {
                                                    self.showLoader?(false)
                                                }
                                                if error == Constants.kNoInternet{
                                                    self.showAlertOnError?()
                                                    self.updatedPagingState?(false)
                                                    return
                                                } else {
                                                    guard let photos = photos else { return }
                                                    switch fetchingState {
                                                    case .newKeyword:
                                                        self.photos = photos
                                                
                                                    case .newPage:
                                                        self.photos += photos
                                                    }
                                                    self.constructCellViewModels()
                                                    
                                                    self.reloadCollectionView?()
                                                    //self.isPagingEnabled = false
                                                    self.updatedPagingState?(false)
                                                }
                                                
        }
    }
    
    public func cleanup() {
        self.photos.removeAll()
        self.cellViewModels.removeAll()
        self.reloadCollectionView?()
    }
    
    private func constructCellViewModels(fetchingState : FetchingState = .newKeyword) {
        self.cellViewModels = []
        for photo in self.photos {
            let cellVM = FlickerPhotoCellViewModel()
            cellVM.initializeValueWith(photo: photo)
            self.cellViewModels.append(cellVM)
        }
    }
    
    
    public func viewDidEndDisplay(index : Int) {
        guard let uRL = self.photos[safe : index]?.imageUrl() else { return }
        DownloadImageService.shared.prolongDownloadForImages(with: uRL)
    }
}
