//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Kunal Patel on 8/10/15.
//  Copyright (c) 2015 Kunal Patel. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    func updateUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            
            var attributedTweetText = NSMutableAttributedString(string: tweet.text)
            
            tweet.hashtags.map { attributedTweetText.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: $0.nsrange) }
            
            tweet.urls.map { attributedTweetText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: $0.nsrange) }
            
            tweet.userMentions.map { attributedTweetText.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: $0.nsrange) }
            
            for _ in tweet.media {
                attributedTweetText.appendAttributedString(NSAttributedString(string: " 📷"))
            }
            
            tweetTextLabel?.attributedText = attributedTweetText;
            
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                let qos = Int(QOS_CLASS_USER_INITIATED.value)
                dispatch_async(dispatch_get_global_queue(qos, 0)) {
                    let imageData = NSData(contentsOfURL: profileImageURL)
                    dispatch_async(dispatch_get_main_queue()) {
                        if profileImageURL == tweet.user.profileImageURL {
                            if imageData != nil {
                                self.tweetProfileImageView?.image = UIImage(data: imageData!)
                            }
                        }
                    }
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
        
    }
    
}

