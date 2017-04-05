//
//  ItemCell.swift
//  POC
//
//  Created by Amit Kumar Battan on 29/03/17.
//  Copyright © 2017 Amit Kumar Battan. All rights reserved.
//

import Foundation
import UIKit

class ItemCell:UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var titleFeaturedSpacing: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    func configureCell(item:Item) {
        titleLabel.text = item.title
        descLabel.text = item.itemDescription
        priceLabel.text = item.displayPrice
        locationLabel.text = item.disPlayLocation
        conditionLabel.text = item.condition
        if let itemThumbnailURL:String = item.itemThumbnailURL, let url:URL = URL(string: itemThumbnailURL) {
            thumbnailImageView.kf.setImage(with: url,
                                           placeholder: nil,
                                           options: [.transition(ImageTransition.fade(1))],
                                           progressBlock: { receivedSize, totalSize in
            },
                                           completionHandler: { image, error, cacheType, imageURL in
            })
        }
        
        if item.isFeatured == true {
            featuredImageView.isHidden = false
            titleFeaturedSpacing.constant = 10
        } else {
            featuredImageView.isHidden = true
            titleFeaturedSpacing.constant = 0
        }
    }
}
