//
//  Item.swift
//  POC
//
//  Created by Amit Kumar Battan on 25/03/17.
//  Copyright © 2017 Amit Kumar Battan. All rights reserved.
//

import Foundation

class Item {
    var itemId:Int?
    var disPlayLocation:String?
    var priceType:String?
    var description:String?
    var isFeatured:Bool = false
    var displayPrice:String?
    var itemImageURL:String?
    var itemThumbnailURL:String?
    var condition:String?
    var date:Date?
    var title:String = ""
    var isSold:Bool = false
    
    init(dict:[String:Any]) {
        self.itemId = dict["id"] as? Int
        self.disPlayLocation = dict["disPlayLocation"] as? String
        self.priceType = (dict["priceTypeData"] as? [String: Any])?["displayPriceType"] as? String
        self.displayPrice = (dict["price"] as? [String: Any])?["displayPrice"] as? String
        self.description = dict["description"] as? String
        self.isFeatured = dict["isFeatured"] as? Bool ?? false
        self.itemImageURL = dict["mediumImage"] as? String
        self.itemThumbnailURL = dict["thumbnail"] as? String
        self.condition = dict["condition"] as? String
        //self.date = dict["condition"] as? String
        self.title = dict["title"] as? String ?? ""
        self.isSold = dict["sold"] as? Bool ?? false

    }

    /*
    "coordinates": {
    "latitude": -34.588,
    "longitude": -58.412
    },
    "displayLocation": "Capital Federal",
    "priceTypeData": {
    "type": "FIXED",
    "displayPriceType": "Fixed Price"
    },
    "additionalLocation": null,
    "seo": null,
    "description": "iphone 6s. Capacidad: 128gb. Color: Gold. Estética: 10/10. Se entrega con cargador y cable originales certificados. Vidrio templado en la pantalla. Anda todo perfecto, libre de fabrica, 4g LTE. Capital federal - Palermo. NO PERMUTO!! Whatsapp: 1136417576",
    "neighborhood": "Palermo",
    "imagesCount": 2,
    "imageColor": "#9955FF",
    "isFeatured": false,
    "price": {
    "amount": 11800,
    "displayPrice": "$11.800",
    "preCurrency": "$",
    "postCurrency": ""
    },
    "mediumImage": "https://images01.olx-st.com/ui/56/22/04/24/m_1490201830_53f50e3f500bd7651ba8556833274a60.jpg",
    "imageWidth": 3024,
    "slug": "//capitalfederal.olx.com.ar/iphone-6s-128gb-gold-iid-932617967",
    "highlighted": false,
    "paidBumpUp": false,
    "thumbnail": "https://images01.olx-st.com/ui/56/22/04/24/t_1490201830_53f50e3f500bd7651ba8556833274a60.jpg",
    "id": 932617967,
    "condition": null,
    "date": {
    "year": 2017,
    "month": 3,
    "day": 22,
    "hour": 13,
    "minute": 57,
    "second": 31,
    "timestamp": "2017-03-22T13:57:31",
    "timezone": "Z"
    },
    "simplifiedCategory": "",
    "fullImage": "https://images01.olx-st.com/ui/56/22/04/24/o_1490201830_53f50e3f500bd7651ba8556833274a60.jpg",
    "isSold": false,
    "titleCustom": "",
    "category": {
    "id": 831,
    "parentId": 830
    },
    "optionals": [
    {
    "name": "slo",
    "label": "",
    "value": "opt-831-apple-iphone-iphone-6s"
    },
    {
    "name": "flo",
    "label": "",
    "value": "opt-831-apple-iphone"
    }
    ],
    "title": "Iphone 6s 128gb gold.",
    "imageHeight": 3653,
    "sold": false,
    "distance": null
 */
}
