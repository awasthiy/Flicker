//
//  FlickerSearchViewController.swift
//  FlickerPhotoSearch
//
//  Created by Yash Awasthi on 19/06/20.
//  Copyright © 2020 Yash Awasthi. All rights reserved.
//

import UIKit

final class FlickerSearchViewController: BaseViewController {

    //MARK:- IBOUTLETS
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Properties
    private var searchStr = "" {
        didSet {
            viewModel.searchStr = searchStr
        }
    }
    var isPagingEnabled: Bool = false
    
    var viewModel : FlickerSearchViewModelProtocol = FlickerSearchViewModel()
    
    fileprivate lazy var footerView : UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = .medium
        loader.color = NaiveDarkAndLightMode.current().darkGrey
        loader.hidesWhenStopped = true
        return loader
    }()
    
    var searchController : UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.hidesNavigationBarDuringPresentation = true
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = Constants.kSearchPlaceholder
        return search
    }()
    
    //MARK:- View Controller's Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initVM()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchController.searchBar.text = searchStr
        changeMode()
    }
    
    fileprivate func initVM() {
        viewModel.showAlertOnError = { [weak self] in
            self?.showAlert(with: Constants.kNoInternet,
                            and: "")
        }
        
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.updatedPagingState = { [weak self] (isPagingEnabled) in
            self?.isPagingEnabled = isPagingEnabled
        }
        
        viewModel.showLoader = { [weak self] (showLader) in
            if showLader {
                self?.showLoading()
            } else {
                self?.hideLoading()
            }
        }
    }
}

//MARK:- Private Methods
private extension FlickerSearchViewController {
    
    func setupUI(){
        configureSearchView()
        configureCollectionView()
        configureNavigationView()
    }
    func configureSearchView(){
        searchController.searchBar.delegate = self
        searchContainer.addSubview(searchController.searchBar)
        searchController.searchBar.sizeToFit()
    }
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FooterLoaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: Constants.kFooterLoaderView)
        
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: collectionView.bounds.width,
                                                                                                           height: 50)
    }
    
    func configureNavigationView(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeMode),
                                               name: NSNotification.Name(Constants.kSelectedMode),
                                               object: nil)
        
        let darkMode = UIBarButtonItem.init( title: "🚀",
                                             style: .plain,
                                             target: self,
                                             action: #selector(toggleDarkMode))
        
        navigationItem.rightBarButtonItems = [darkMode]
    }
}

//MARK:- UISearchBarDelegate Methods
extension FlickerSearchViewController : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchStr = ""
        isPagingEnabled = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchStr = searchText
        isPagingEnabled = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchStr = searchBar.text else { return }
        guard searchStr.count > 0 else { return }
        viewModel.cleanup()
        searchController.isActive = false
        searchController.searchBar.text = searchStr
        self.searchStr = searchStr
        viewModel.fetchData(fetchingState: .newKeyword)
    }
}

//MARK:- CollectionViewDataSource and FlowLayout Methods
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
        
        self.showDetailPage(indexPath: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
 
        let lastRowIndex = collectionView.numberOfItems(inSection: 0) - 1
        
        if indexPath.row == lastRowIndex{
            isPagingEnabled = true
            viewModel.fetchData(fetchingState: .newPage)
            return
        }
        guard let cell = cell as? FlickerPhotoCell else { return }
        cell.fillUI(indexPath : indexPath)
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

//MARK:- Utility Methods 
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
    
    @objc private func changeMode() {
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
    
    func showDetailPage(indexPath : IndexPath, animated : Bool) {
        guard let imageDetailViewController = UIStoryboard.init(name: Constants.kMain, bundle: nil).instantiateViewController(withIdentifier: Constants.kImageDetailViewController) as? ImageDetailViewController else { return }
        imageDetailViewController.viewModel = self.viewModel.getCellViewModel(indexPath: indexPath)
        searchController.isActive = false
        self.navigationController?.pushViewController(imageDetailViewController, animated: animated)
    }
}
