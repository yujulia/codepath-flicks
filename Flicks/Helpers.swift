//
//  Helpers.swift
//  Flicks
//
//  Created by Julia Yu on 2/17/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import Foundation
import AFNetworking

class Helpers {
    
    static func loadImage(urlString: String, imageview: UIImageView) {
        Helpers.loadImage(urlString, imageview: imageview, callback:nil)
    }
    
    static func loadImage(urlString: String, imageview: UIImageView, callback: (()->Void)?) {
        
        if let url = NSURL(string:urlString) {
            let urlRequest = NSURLRequest(URL: url)
            
            imageview.alpha = 0.0
            
            imageview.setImageWithURLRequest(
                urlRequest,
                placeholderImage: nil,
                success: {(req: NSURLRequest, response: NSURLResponse?, image: UIImage) -> Void in
                    
                    imageview.image = image
                    
                    UIView.animateWithDuration(0.6,
                        animations:  {() in
                            imageview.alpha = 1.0
                        },
                        completion: {(Bool) in
                            if let callback = callback {
                                callback()
                            }
                        }
                    )
                },
                failure: nil
            )
            
        }

    }
}