//
//  FlickerPhotoSearchVCTests.swift
//  FlickerPhotoSearchTests
//
//  Created by Yash Awasthi on 30/06/20.
//  Copyright © 2020 Yash awasthi. All rights reserved.
//

import XCTest
@testable import FlickerPhotoSearch

class FlickerPhotoSearchVCTests: XCTestCase {
    
    var searchVC: FlickerSearchViewController!
    let mockSearchViewModel : FlickerSearchViewModel = FlickerSearchViewModel()
    var detailVC : ImageDetailViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: FlickerSearchViewController = storyboard.instantiateViewController(withIdentifier: "FlickerSearchViewController") as! FlickerSearchViewController
        let navigationController = UINavigationController()
        searchVC = vc
        _ = searchVC.view // To call viewDidLoad
        navigationController.viewControllers = [searchVC]
        
        let service = MockDataService()
        mockSearchViewModel.networkService = service
        searchVC.viewModel = mockSearchViewModel
        searchVC.viewModel.searchStr = "Swift"
        
        let detailpage: ImageDetailViewController = storyboard.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        detailVC = detailpage
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        mockSearchViewModel.fetchData()
        XCTAssertTrue(searchVC.collectionView.numberOfItems(inSection: 0) == 1)
    }
    
    func test_tapToDetailPage() {
        mockSearchViewModel.fetchData()
        searchVC.showDetailPage(indexPath: IndexPath(row: 0, section: 0), animated: false)
        XCTAssertFalse(searchVC.searchController.isActive)
    }
    
    func test_detailPageValidate() {
        mockSearchViewModel.fetchData()
        searchVC.showDetailPage(indexPath: IndexPath(row: 0, section: 0), animated: false)
        XCTAssertTrue(searchVC.navigationController?.viewControllers.count == 2)
    }
    
    func test_detailPageValidate1() {
        mockSearchViewModel.fetchData()
        searchVC.showDetailPage(indexPath: IndexPath(row: 0, section: 0), animated: false)
        guard let detailVC = searchVC.navigationController?.topViewController as? ImageDetailViewController else { return }
        _ = detailVC.view
        sleep(1)
        XCTAssertTrue(detailVC.title != nil)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
