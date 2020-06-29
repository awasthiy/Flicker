//
//  FlickerSearchViewController+Ext.swift
//  FlickerPhotoSearch
//
//  Created by Yash Awasthi on 22/06/20.
//  Copyright © 2020 Yash Awasthi. All rights reserved.
//

import UIKit

extension FlickerSearchViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if self.viewModel.numberOfItems == 0 {
            self.collectionView.setEmptyMessage(Constants.kNoData)
        } else {
            self.collectionView.restore()
        }
        return self.viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.kFlickerPhotoCell,
                                                            for: indexPath) as? FlickerPhotoCell else { return UICollectionViewCell()}
        let cellViewModel = viewModel.getCellViewModel(indexPath : indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.showDetailPage(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        
        let lastRowIndex = collectionView.numberOfItems(inSection: 0) - 1
        
        if indexPath.row == lastRowIndex{
            isPagingEnabled = true
            viewModel.fetchData(fetchingState: .newPage)
            return
        }
        if let cell = cell as? FlickerPhotoCell {
            // URL will be already exists to its cellVM
            //guard let url = self.viewModel.photos[safe: indexPath.row]?.imageUrl() else { return }
            cell.fillUI(indexPath : indexPath)

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard !isPagingEnabled else { return }
        viewModel.viewDidEndDisplay(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalHeight: CGFloat = (view.frame.width / 2)
        let totalWidth: CGFloat = (view.frame.width / 2)
        return CGSize(width: ceil(totalWidth - 8), height: ceil(totalHeight - 8))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: Constants.kFooterLoaderView,
                                                                         for: indexPath)
            footer.addSubview(footerView)
            footerView.frame = CGRect(x: 0, y: -50, width: collectionView.bounds.width, height: 50)
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if isPagingEnabled {
            footerView.frame.origin.y = 0
        }
        footerView.startAnimating()
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        footerView.stopAnimating()
    }
}


extension FlickerSearchViewController {
    
    @objc func toggleDarkMode(){
        let mode = NaiveDarkAndLightMode.current()
        if mode == .Dark {
            NaiveDarkAndLightMode.applyMode(mode: .Light)
        }else{
            NaiveDarkAndLightMode.applyMode(mode: .Dark)
        }
        NotificationCenter.default.post(name: NSNotification.Name(Constants.kSelectedMode),
                                        object: nil)
    }
    
    @objc func changeMode() {
        UIView.animate(withDuration: 0.9, animations: {
            if self.viewModel.numberOfItems == 0 {
                self.collectionView.reloadData()
            }
            self.footerView.color = NaiveDarkAndLightMode.current().darkGrey
            self.searchController.searchBar.barStyle = NaiveDarkAndLightMode.current().barStyle
            self.view.backgroundColor = NaiveDarkAndLightMode.current().background
            self.searchController.searchBar.keyboardAppearance = NaiveDarkAndLightMode.current().keyBoardAppearance
            self.searchController.searchBar.tintColor = NaiveDarkAndLightMode.current().darkGrey
            self.searchContainer.backgroundColor = NaiveDarkAndLightMode.current().background
            self.navigationController?.navigationBar.barTintColor = NaiveDarkAndLightMode.current().fillColor
            self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.07868818194, green: 0.6650877595, blue: 0.992734015, alpha: 1)
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : NaiveDarkAndLightMode.current().darkGrey]
        }) { (done) in }
    }
    
    func showDetailPage(indexPath : IndexPath) {
        guard let imageDetailViewController = UIStoryboard.init(name: Constants.kMain, bundle: nil).instantiateViewController(withIdentifier: Constants.kImageDetailViewController) as? ImageDetailViewController else { return }
        imageDetailViewController.viewModel = self.viewModel.getCellViewModel(indexPath: indexPath)
        searchController.isActive = false
        self.navigationController?.pushViewController(imageDetailViewController, animated: true)
    }
}
