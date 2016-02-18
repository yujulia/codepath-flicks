//
//  FlicksDetailViewController.swift
//  Flicks
//
//  Created by Julia Yu on 2/16/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit
import AFNetworking

class FlicksDetailViewController: UIViewController {
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailScroll: UIScrollView!
    @IBOutlet weak var detailOverview: UILabel!
    @IBOutlet weak var detailTitle: UILabel!
    
    var detailData: Movie?
    
    func loadHighRes() {
        if let detailData = self.detailData {
            let highresURL = NSURL(string: detailData.highresPoster!)
            self.detailImage.setImageWithURL(highresURL!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailScroll.contentSize = CGSize(width: 320, height: self.view.frame.height*1.6)

        if let detailData = self.detailData {

            detailTitle.text = detailData.title
            detailOverview.text = detailData.overview
            detailOverview.sizeToFit()
            
            Helpers.loadImage(detailData.lowresPoster!, imageview: self.detailImage, callback: loadHighRes)
            
        }
    
    }

}
