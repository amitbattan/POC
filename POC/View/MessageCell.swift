//
//  MessageCell.swift
//  POC
//
//  Created by Amit Kumar Battan on 05/04/17.
//  Copyright © 2017 Amit Kumar Battan. All rights reserved.
//

import Foundation
import UIKit

class MessageCell:UITableViewCell {
    @IBOutlet weak var msgLabel: UILabel!
    
    func configureCell(message:String) {
        msgLabel.text = message
    }
}
