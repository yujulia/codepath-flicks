//
//  FlicksTableViewCell.swift
//  Flicks
//
//  Created by Julia Yu on 2/16/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit
import AFNetworking

class FlicksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var cellData: Movie?{
        didSet {
            if let data = cellData {
                
                self.titleLabel.text = data.title
                self.descLabel.text = data.overview
                
                if let urlString = data.thumbnailPoster {
                    let url = NSURL(string:urlString)
                    self.thumbnail.setImageWithURL(url!)
                }
    
            }
        }
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
