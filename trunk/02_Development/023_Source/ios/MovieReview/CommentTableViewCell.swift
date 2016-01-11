//
//  CommentTableViewCell.swift
//  ReviewMovies
//
//  Created by Nguyen Hanh on 4/15/15.
//  Copyright (c) 2015 Nguyen Hanh. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell, CommentTableViewCellProtocol{
    
    @IBOutlet weak var rateStar: RatingView!
    @IBOutlet weak var account: UILabel!
    @IBOutlet weak var comment: UITextView!
    
    /* Protocol */
    
    func setRate( val : Double)
    {
        if (val == 0)
        {
            rateStar.hidden = true
        }
        else
        {
            rateStar.hidden = false
            rateStar.value = CGFloat( val )
        }
    }
    func setUsername( val: String )
    {
        account.text = val
    }
    func setCmmt( val: String )
    {
        comment.text = val
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
}
