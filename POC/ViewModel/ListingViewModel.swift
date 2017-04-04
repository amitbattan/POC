//
//  ListingViewModel.swift
//  POC
//
//  Created by Amit Kumar Battan on 25/03/17.
//  Copyright © 2017 Amit Kumar Battan. All rights reserved.
//

import Foundation

class ListingViewModel {
    private(set) var items = [Item]()
    var searchKey:SearchKey?
    var totalItems:Int = 0
    var isFetching:Bool = false
    var nextQuery:String?
    var queryString:String?
    
    weak var delegate: ListingViewModelDelegate?
    
    init() {
    }

    func fetchNextPage() {
        if isFetching == true { //retrun if request alreay in process
            return
        }
        
        if nextQuery == nil { //retrun if there is no next page available
            delegate?.endOfList()   //and call end of list
            return
        }
        
        isFetching = true
        fetchItemsFromNextPage()
    }
    
    func fetchItems(queryString:String) {
        if queryString.trimmingCharacters(in: .whitespaces).characters.count == 0 {
            delegate?.listFetched(isNextPage: false, errorMessage: "Enter a valid query string")
            return
        }
        self.queryString = queryString
        //get data from local DB
        if let items:[Item] = getListOfItemFromLocalStorage(queryString: queryString), items.count > 0 {
            self.items = items
            delegate?.listFetched(isNextPage: false, errorMessage: nil)
        } else {
            //get data from API
            fetchItemsFromServer(queryString: queryString)
        }
    }
    
    //fetch data from API
    func fetchItemsFromServer(queryString:String) {
        let requestBuilder = RequestBuilder()
        let request = requestBuilder.requestOlxItems(searchString: queryString, offSet: 10)
        WebServiceManager.shared.fetch(URLRequest: request) { [weak self] (response, error) in
            self?.items.removeAll()
            self?.completionHandlerForItems(response: response, error: error)
        }
    }
    
    //get data from local DB
    func getListOfItemFromLocalStorage(queryString:String) -> [Item]? {
        searchKey = SearchKey.fetchSearchKey(searchString: queryString)
        let items = searchKey?.item?.allObjects as? [Item]
        let sortedItems = items?.sorted(by: { (item1, item2) -> Bool in
            if let date1 = item1.date, let date2 = item2.date {
                return date1 > date2
            } else {
                return true
            }
        })
        return sortedItems
    }

    //web service completion handler
    func completionHandlerForItems(response:Any?, error:Error?) {
        defer {
            isFetching = false
        }
        
        //retun if response is nil or error is not nil
        guard error == nil, let response = response as? [String:Any] else {
            delegate?.listFetched(isNextPage: false, errorMessage: "Some thing went wrong")
            return
        }

        //parse meta data
        if let metadata = response["metadata"] as? [String:Any] {
            if let next = metadata["next"] as? String, next.characters.count > 0 {
                nextQuery = metadata["next"] as? String
            } else {
                nextQuery = nil
            }
            totalItems = metadata["total"] as? Int ?? 0
        }

        //parse item array
        if let data = response["data"] as? [[String:Any]] {
            if data.count > 0 {
                //parse item array
                let objects = data.map({ (dict) -> Item in
                    let item =   Item.createItemFor(dict: dict)
                    item.searchKey = searchKey
                    return item
                })
                let objectsSet = NSSet(array: objects)
                searchKey?.addToItem(objectsSet)
                
                items.append(contentsOf: objects)
                //notify with next page info and no error message
                delegate?.listFetched(isNextPage: (nextQuery != nil), errorMessage: nil)
            } else {
                //no data available
                if items.count == 0 {
                    //if there is no item for search key, delete it from local DB
                    searchKey?.delete()
                    searchKey = nil
                }
                //notify error message and no next page info
                delegate?.listFetched(isNextPage: false, errorMessage: "No Data Available")
            }
        } else {
            //list of item against search query is not exist
            //notify error message and no next page info
            delegate?.listFetched(isNextPage: false, errorMessage: "Some thing went wrong")
        }
    }

    //API call for next page
    func fetchItemsFromNextPage() {
        let requestBuilder = RequestBuilder()
        guard let nextQuery:String = nextQuery, let request = requestBuilder.requestNextPageForOlxItems(query: nextQuery) else {
            //return and make end of list if request is not valid
            isFetching = false
            delegate?.endOfList()
            return
        }

        WebServiceManager.shared.fetch(URLRequest: request) { [weak self] (response, error) in
            self?.completionHandlerForItems(response: response, error: error)
        }
    }

    //refresh list (pull to refresh)
    func refresh() {
        //Delete data from local DB
        searchKey?.delete()
        searchKey = nil

        //Fetch data from Server
        if let queryString = queryString {
            fetchItems(queryString: queryString)
        }
    }
    
    //retry in case of error (user tab on error message)
    func retry() {
        if items.count == 0 {
            //call for fresh request if item list is empty
            if let queryString = queryString {
                fetchItems(queryString: queryString)
            }
        } else {
            //call for next page request if item list is not empty
            fetchNextPage()
        }
    }
    
}

protocol ListingViewModelDelegate: class {
    func listFetched(isNextPage:Bool, errorMessage:String?)
    func endOfList()
}
