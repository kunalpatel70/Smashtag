//
//  TweetImageTableViewCell.swift
//  Smashtag
//
//  Created by Kunal Patel on 8/13/15.
//  Copyright (c) 2015 Kunal Patel. All rights reserved.
//

import UIKit

class TweetImageTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageURL: NSURL? { didSet { fetchImage() } }
    
    private func fetchImage() {
        tweetImageView?.image = nil
        if let url = imageURL {
            spinner?.startAnimating()
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            dispatch_async(dispatch_get_global_queue(qos, 0)) {
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageURL {
                        if imageData != nil {
                            self.tweetImageView?.image = UIImage(data: imageData!)
                        } else {
                            self.tweetImageView?.image = nil
                        }
                        self.spinner?.stopAnimating()
                    }
                }
            }
        }
    }
    
    
}
