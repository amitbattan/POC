//
//  SearchKey+CoreDataProperties.swift
//  POC
//
//  Created by Amit Kumar Battan on 05/04/17.
//  Copyright © 2017 Amit Kumar Battan. All rights reserved.
//

import Foundation
import CoreData


extension SearchKey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchKey> {
        return NSFetchRequest<SearchKey>(entityName: "SearchKey")
    }

    @NSManaged public var searchKey: String?
    @NSManaged public var item: NSSet?

    class func createSearchFor(searchString:String, context:NSManagedObjectContext = DataManager.sharedInstance.sharedManagedObjectContext) -> SearchKey {
        let searchStringLowerCased = searchString.lowercased()
        let searchKey:SearchKey = NSEntityDescription.insertNewObject(forEntityName: "SearchKey", into: context) as! SearchKey
        searchKey.searchKey = searchStringLowerCased
        
        DataManager.sharedInstance.saveContext()
        return searchKey
    }
    
    class func fetchSearchKey(searchString:String)  -> SearchKey {
        let searchStringLowerCased = searchString.lowercased()
        let fetchRequest:NSFetchRequest<SearchKey> = SearchKey.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "searchKey == %@", searchStringLowerCased)
        do {
            let context = DataManager.sharedInstance.sharedManagedObjectContext
            let searchKeys:[SearchKey] = try context.fetch(fetchRequest)
            if searchKeys.count > 0 {
                return searchKeys[0]
            }
            
        } catch {
            print("Failed to fetch serach key: \(error)")
        }
        return createSearchFor(searchString: searchString)
    }
    
    func delete(context:NSManagedObjectContext = DataManager.sharedInstance.sharedManagedObjectContext) {
        context.delete(self)
        context.processPendingChanges()
        DataManager.sharedInstance.saveContext()
    }
    
    func save(context:NSManagedObjectContext = DataManager.sharedInstance.sharedManagedObjectContext) {
        DataManager.sharedInstance.saveContext()
    }

}

// MARK: Generated accessors for item
extension SearchKey {

    @objc(addItemObject:)
    @NSManaged public func addToItem(_ value: Item)

    @objc(removeItemObject:)
    @NSManaged public func removeFromItem(_ value: Item)

    @objc(addItem:)
    @NSManaged public func addToItem(_ values: NSSet)

    @objc(removeItem:)
    @NSManaged public func removeFromItem(_ values: NSSet)

}
