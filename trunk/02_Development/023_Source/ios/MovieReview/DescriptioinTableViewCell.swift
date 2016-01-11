//
//  DescriptioinTableViewCell.swift
//  MovieReview
//
//  Created by Nguyen Hanh on 7/6/15.
//  Copyright (c) 2015 MDI ASTEC VN CO., LTD. All rights reserved.
//

import UIKit

class DescriptioinTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var comment: UITextField!
    @IBAction func sunmit(sender: AnyObject) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
