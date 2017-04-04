//
//  DetailViewController.swift
//  POC
//
//  Created by Amit Kumar Battan on 30/03/17.
//  Copyright © 2017 Amit Kumar Battan. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var item:Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        featuredImageView.isHidden = !item.isFeatured
    }
    
    override func viewWillLayoutSubviews() {
        titleLabel.preferredMaxLayoutWidth  = titleLabel.bounds.width
        locationLabel.preferredMaxLayoutWidth  = locationLabel.bounds.width
        descLabel.preferredMaxLayoutWidth  = descLabel.bounds.width
    }

}
