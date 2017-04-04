//
//  Item+CoreDataProperties.swift
//  POC
//
//  Created by Amit Kumar Battan on 05/04/17.
//  Copyright © 2017 Amit Kumar Battan. All rights reserved.
//

import Foundation
import CoreData

extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var condition: String?
    @NSManaged public var date: Date?
    @NSManaged public var disPlayLocation: String?
    @NSManaged public var displayPrice: String?
    @NSManaged public var isFeatured: Bool
    @NSManaged public var isSold: Bool
    @NSManaged public var itemDescription: String?
    @NSManaged public var itemId: String?
    @NSManaged public var itemImageURL: String?
    @NSManaged public var itemThumbnailURL: String?
    @NSManaged public var priceType: String?
    @NSManaged public var title: String?
    @NSManaged public var searchKey: SearchKey?

    class func createItemFor(dict:[String:Any], context:NSManagedObjectContext = DataManager.sharedInstance.sharedManagedObjectContext) -> Item {
        let item:Item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as! Item
        if let itemId = dict["id"] as? Int64 {
            item.itemId = "\(itemId)"
        }
        item.disPlayLocation = dict["disPlayLocation"] as? String
        item.priceType = (dict["priceTypeData"] as? [String: Any])?["displayPriceType"] as? String
        item.displayPrice = (dict["price"] as? [String: Any])?["displayPrice"] as? String
        item.itemDescription = dict["description"] as? String
        item.isFeatured = dict["isFeatured"] as? Bool ?? false
        item.itemImageURL = dict["mediumImage"] as? String
        item.itemThumbnailURL = dict["thumbnail"] as? String
        item.condition = dict["condition"] as? String
        item.title = dict["title"] as? String ?? ""
        item.isSold = dict["sold"] as? Bool ?? false
        
        if let dateObj = dict["date"] as? [String:Any], let timestamp = dateObj["timestamp"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //Your date format
            let date = dateFormatter.date(from: timestamp)
            item.date = date
        }
        
        DataManager.sharedInstance.saveContext()
        return item
    }
}
