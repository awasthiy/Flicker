//
//  FlickerPhotoSearchTests.swift
//  FlickerPhotoSearchTests
//
//  Created by Yash Awasthi on 19/06/20.
//  Copyright © 2020 Yash Awasthi. All rights reserved.
//

import XCTest
@testable import FlickerPhotoSearch

class FlickerPhotoSearchTests: XCTestCase {
    
    var mockSearchViewModel : FlickerSearchViewModel = FlickerSearchViewModel()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        let service = MockDataService()
        mockSearchViewModel.networkService = service
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_fetchDataEmpty() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //let expectation = self.expectation(description: "Expected load countries from cloud to fail")
        mockSearchViewModel.fetchData()
        XCTAssertTrue(self.mockSearchViewModel.numberOfItems == 0)
        //waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_fetchDataForDataSet1() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //let expectation = self.expectation(description: "Expected load countries from cloud to fail")
        mockSearchViewModel.searchStr = "iOS"
        mockSearchViewModel.fetchData()
        XCTAssertTrue(self.mockSearchViewModel.numberOfItems == 1)
        //waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_fetchDataForDataSet2() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //let expectation = self.expectation(description: "Expected load countries from cloud to fail")
        mockSearchViewModel.searchStr = "Swift"
        mockSearchViewModel.fetchData(fetchingState: .newPage)
        XCTAssertTrue(self.mockSearchViewModel.numberOfItems == 1)
        //waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_fetchDataForDataSet3() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //let expectation = self.expectation(description: "Expected load countries from cloud to fail")
        mockSearchViewModel.searchStr = "SwiftUI"
        mockSearchViewModel.fetchData(fetchingState: .newKeyword)
        XCTAssertTrue(self.mockSearchViewModel.numberOfItems == 1)
        //waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_fetchDataForDataSet4() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //let expectation = self.expectation(description: "Expected load countries from cloud to fail")
        mockSearchViewModel.searchStr = "No Input"
        mockSearchViewModel.fetchData(fetchingState: .newKeyword)
        XCTAssertTrue(self.mockSearchViewModel.numberOfItems == 0)
        //waitForExpectations(timeout: 3, handler: nil)
    }
    
    func test_cleanup() {
        mockSearchViewModel.cleanup()
        XCTAssertTrue(self.mockSearchViewModel.cellViewModels.count == 0)
    }
    
    func test_getCellViewModel() {
        mockSearchViewModel.searchStr = "Swift"
        mockSearchViewModel.fetchData(fetchingState: .newPage)
        XCTAssertNotNil(mockSearchViewModel.getCellViewModel(indexPath: IndexPath(row: 0, section: 0)))
    }
    
    func test_viewDidEndDisplay() {
        mockSearchViewModel.viewDidEndDisplay(index: 1)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}


class MockDataService : DataService {
    func getPhotosData(for searchStr: String,
                       with pageNum: Int,
                       completion: @escaping PhotoCollectionStringBlock) {
        if searchStr != "No Input" {
            completion(MockStubGenerator.getMockPhotos(), nil)
        } else {
            completion([], Constants.kNoInternet)
        }
    }
}

class MockStubGenerator {
    class func getMockPhotos() -> [Photo] {
        let photoArr : [Photo] = [Photo(id: "1",
                                         owner: "",
                                         secret: "",
                                         server: "",
                                         farm: 1,
                                         title: "photo1",
                                         ispublic: 0,
                                         isfriend: 0,
                                         isfamily: 0)
        ]
        return photoArr
    }
}
