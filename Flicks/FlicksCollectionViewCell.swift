//
//  FlicksCollectionViewCell.swift
//  Flicks
//
//  Created by Julia Yu on 2/17/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit

class FlicksCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    var cellData: Movie?{
        didSet {
            if let data = cellData {
                if let urlString = data.thumbnailPoster {
                    let url = NSURL(string:urlString)
                    self.posterImage.setImageWithURL(url!)
                }
                
            }
        }
    }
}
