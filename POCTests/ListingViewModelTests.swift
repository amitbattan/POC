//
//  ListingViewModelTests.swift
//  POC
//
//  Created by Amit Kumar Battan on 03/04/17.
//  Copyright © 2017 Amit Kumar Battan. All rights reserved.
//

import XCTest

@testable import POC

class MockableListViewModel: ListingViewModel {
    var fetchItemsFromNextPageCalled:Bool = false
    var fetchItemsFromServerCalled:Bool = false
    var fetchItemsCalled:Bool = false
    override func fetchItemsFromNextPage() {
        print("-fetchItemsFromNextPage-")
        fetchItemsFromNextPageCalled = true
    }

    override func fetchItemsFromServer(queryString: String) {
        print("-fetchItemsFromServer-")
        fetchItemsFromServerCalled = true
    }
    
    override func fetchItems(queryString: String) {
        super.fetchItems(queryString: queryString)
        fetchItemsCalled = true
    }

}


class ListingViewModelTests: XCTestCase, ListingViewModelDelegate {
    
    var viewModel = MockableListViewModel()
    var errorString:String?
    var endOfListingCalled:Bool = false
    var listingFetchedCalled:Bool = false
    var isNext:Bool = false
    
    override func setUp() {
        super.setUp()
        viewModel.delegate = self
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func fetchData() -> Any {
        var response:Any = ""
        if let path = Bundle(for: type(of: self)).path(forResource: "Resourse", ofType:"json") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                do {
                    response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                }catch _ {}
            }
        }
        return response
    }
    
    func resetAllVars() {
//        viewModel = MockableListViewModel()
        errorString = nil
        endOfListingCalled = false
        listingFetchedCalled = false
        viewModel.fetchItemsFromNextPageCalled = false
        viewModel.fetchItemsFromServerCalled = false
        viewModel.fetchItemsCalled = false
    }
    
    func endOfList() {
        endOfListingCalled = true
    }
    
    func listFetched(isNextPage: Bool, errorMessage: String?) {
        print("-listFetched-")
        errorString = errorMessage
        listingFetchedCalled = true
        isNext = isNextPage
    }

    weak var delegate: ListingViewModelDelegate?
    
    func testFetchNextPage() {
        resetAllVars()
        viewModel.isFetching = true
        viewModel.fetchNextPage()
        XCTAssertFalse(viewModel.fetchItemsFromNextPageCalled)
        XCTAssertFalse(endOfListingCalled)
        
        resetAllVars()
        viewModel.isFetching = false
        viewModel.nextQuery = nil
        viewModel.fetchNextPage()
        XCTAssertFalse(viewModel.fetchItemsFromNextPageCalled)
        XCTAssertTrue(endOfListingCalled)
        
        resetAllVars()
        viewModel.isFetching = false
        viewModel.nextQuery = "some value"
        viewModel.fetchNextPage()
        XCTAssertFalse(endOfListingCalled)
        XCTAssertTrue(viewModel.fetchItemsFromNextPageCalled)
    }
    
    func testFetchItems() {
        resetAllVars()
        viewModel.fetchItems(queryString: "")
        XCTAssertTrue(listingFetchedCalled)
        XCTAssertFalse(isNext)
        XCTAssertEqual(errorString, "Enter a valid query string")
        XCTAssertFalse(viewModel.fetchItemsFromServerCalled)

        resetAllVars()
        viewModel.fetchItems(queryString: "  ")
        XCTAssertTrue(listingFetchedCalled)
        XCTAssertFalse(isNext)
        XCTAssertEqual(errorString, "Enter a valid query string")
        XCTAssertFalse(viewModel.fetchItemsFromServerCalled)
        
        print("***********************")
        resetAllVars()
        var searchKey = SearchKey.fetchSearchKey(searchString: "abcdef")
        searchKey.delete()
        viewModel.fetchItems(queryString: "abcdef")
        XCTAssertFalse(listingFetchedCalled)
        XCTAssertTrue(viewModel.fetchItemsFromServerCalled)
        
        searchKey = SearchKey.fetchSearchKey(searchString: "abcdef")
        let dict = ["displayLocation":"Pilar","priceTypeData":["type":"FIXED","displayPriceType":"Fixed Price"],"description":"ESTA SEMANA 2013","isFeatured":false,"price":["amount":179000,"displayPrice":"$179.000","preCurrency":"$","postCurrency":""],"mediumImage":"https://images01.olx-st.com/ui/51/67/45/85/m_1487687872_193243718e436ebc45c3464b28372366.jpg","thumbnail":"https://images01.olx-st.com/ui/51/67/45/85/t_1487687872_193243718e436ebc45c3464b28372366.jpg","id":927820591,"condition":"used","date":["timestamp":"2017-03-30T16:34:23"],"isSold":false,"title":"Mitsubishi Montero io 1.8 4x4","sold":false] as [String : Any]
        let item = Item.createItemFor(dict: dict)
        searchKey.addToItem(item)

        resetAllVars()
        viewModel.fetchItems(queryString: "abcdef")
        XCTAssertFalse(viewModel.fetchItemsFromServerCalled)
        XCTAssertTrue(listingFetchedCalled)
        XCTAssertFalse(isNext)
        XCTAssertNil(errorString)
    }
    
    func testCompletionHandlerForItems() {
        resetAllVars()
        viewModel.completionHandlerForItems(response: nil, error: nil)
        XCTAssertTrue(listingFetchedCalled)
        XCTAssertFalse(isNext)
        XCTAssertEqual(errorString, "Some thing went wrong")
        XCTAssertFalse(viewModel.isFetching)

        resetAllVars()
        viewModel.isFetching = true
        viewModel.completionHandlerForItems(response: self.fetchData(), error: nil)
        XCTAssertTrue(listingFetchedCalled)
        XCTAssertTrue(isNext)
        XCTAssertNil(errorString)
        XCTAssertEqual(viewModel.nextQuery, "/items?location=www.olx.com.ar&pageSize=15&searchTerm=Ios&offset=45")
        XCTAssertEqual(viewModel.totalItems, 46)
        XCTAssertFalse(viewModel.isFetching)

        resetAllVars()
        let response = ["data":[], "metadata":["next":"", "total":0]] as [String : Any]
        viewModel.completionHandlerForItems(response: response, error: nil)
        XCTAssertTrue(listingFetchedCalled)
        XCTAssertFalse(isNext)
        XCTAssertEqual(errorString, "No Data Available")
        XCTAssertNil(viewModel.nextQuery)
        XCTAssertEqual(viewModel.totalItems, 0)
        XCTAssertFalse(viewModel.isFetching)
    }
    
    func testRefresh() {
        resetAllVars()
        viewModel.queryString = nil
        viewModel.refresh()
        XCTAssertNil(viewModel.searchKey)
        XCTAssertFalse(viewModel.fetchItemsCalled)
        
        resetAllVars()
        viewModel.queryString = "some value"
        viewModel.refresh()
        XCTAssertTrue(viewModel.fetchItemsCalled)
    }

}

