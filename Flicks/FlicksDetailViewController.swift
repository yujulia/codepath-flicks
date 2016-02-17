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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailScroll.contentSize = CGSize(width: 320, height: self.view.frame.height*1.6)

        if let detailData = self.detailData {

            detailTitle.text = detailData.title
            
            detailOverview.text = detailData.overview
            detailOverview.sizeToFit()
            
            let url = NSURL(string:detailData.highresPoster!)
            self.detailImage.setImageWithURL(url!)
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
