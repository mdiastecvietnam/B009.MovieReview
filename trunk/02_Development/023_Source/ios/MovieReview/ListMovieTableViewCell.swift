//
//  ListMovieTableCellViewTableViewCell.swift
//  MovieReviewApp
//
//  Created by Nguyen Hanh on 6/29/15.
//  Copyright (c) 2015 Nguyen Hanh. All rights reserved.
//

import UIKit

class ListMovieTableViewCell: UITableViewCell, ListMovieItemViewProtocol {

    @IBOutlet weak var porter: UIImageView!
    @IBOutlet weak var MovieName: UILabel!
    
    @IBOutlet weak var rating: RatingView!
    
    func setTitle(title: String)
    {
        MovieName.text = title
        MovieName.numberOfLines = 2
    }
    
    func setRate(val:Double?)
    {
        rating.frame.size.height = 10
        rating.frame.size.width=80
        rating.editable = false
        if( val != nil )
        {
            rating.value = CGFloat(val!)
            rating.hidden = false
        }
        else
        {
            rating.hidden = true
        }
    }
    
    func setPoster(data: NSData!)
    {
        porter.image =  data == nil ? nil : UIImage(data: data!)
    }

    override func awakeFromNib()
    {
        super.awakeFromNib()
        cleanUp()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cleanUp()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func cleanUp()
    {
        MovieName.text = nil
        porter.image = nil
    }
}
