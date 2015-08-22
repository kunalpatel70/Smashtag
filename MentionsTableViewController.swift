//
//  TweetDetailTableViewController.swift
//  Smashtag
//
//  Created by Kunal Patel on 8/13/15.
//  Copyright (c) 2015 Kunal Patel. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {
    
    var tweet: Tweet? {
        didSet {
            title = tweet?.user.screenName
            if let media = tweet?.media {
                if media.count > 0 {
                    mentions.append(Mentions(title: "Images",
                        data: media.map { MentionItem.Image($0.url, $0.aspectRatio) }))
                }
            }
            if let urls = tweet?.urls {
                if urls.count > 0 {
                    mentions.append(Mentions(title: "URLs",
                        data: urls.map { MentionItem.Keyword($0.keyword) }))
                }
            }
            if let hashtags = tweet?.hashtags {
                if hashtags.count > 0 {
                    mentions.append(Mentions(title: "Hashtags",
                        data: hashtags.map { MentionItem.Keyword($0.keyword) }))
                }
            }
            if let users = tweet?.userMentions {
                var userItems = [MentionItem.Keyword("@" + tweet!.user.screenName)]
                if users.count > 0 {
                    userItems += users.map { MentionItem.Keyword($0.keyword) }
                }
                mentions.append(Mentions(title: "Users", data: userItems))
            }
        }
    }
    
    var mentions: [Mentions] = []
    
    struct Mentions: Printable
    {
        var title: String
        var data: [MentionItem]
        
        var description: String { return "\(title): \(data)" }
    }
    
    enum MentionItem: Printable
    {
        case Keyword(String)
        case Image(NSURL, Double)
        
        var description: String {
            switch self {
            case .Keyword(let keyword): return keyword
            case .Image(let url, _): return url.path!
            }
        }
    }
    
    private struct Storyboard {
        static let KeywordCellReuseIdentifier = "Keyword Cell"
        static let ImageCellReuseIdentifier = "Image Cell"
        static let KeywordSegueIdentifier = "From Keyword"
        static let ImageSegueIdentifier = "Show Image"
        static let WebSegueIdentifier = "Show URL"
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].data.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let mention = mentions[indexPath.section].data[indexPath.row]
        
        switch mention {
        case .Keyword(let keyword):
            let cell = tableView.dequeueReusableCellWithIdentifier(
                CellReuseIdentifier.Keyword,
                forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel?.text = keyword
            return cell
        case .Image(let url, let ratio):
            let cell = tableView.dequeueReusableCellWithIdentifier(
                CellReuseIdentifier.Image,
                forIndexPath: indexPath) as! TweetImageTableViewCell
            cell.imageURL = url
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .Image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let mention = mentions[indexPath.section]
        
        if mention.title == "URLs" {
            let mentionKeyword = mention.data[indexPath.row]
            switch mentionKeyword {
            case .Keyword(let url):
                UIApplication.sharedApplication().openURL(NSURL(string: url)!)
            default: break
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mention = mentions[indexPath.section]
        
        if mention.title == "URLs" {
            performSegueWithIdentifier(SegueIdentifier.Web, sender: tableView.cellForRowAtIndexPath(indexPath))
        } else if mention.title == "Hashtags" || mention.title == "Users" {
            performSegueWithIdentifier(SegueIdentifier.Keyword, sender: tableView.cellForRowAtIndexPath(indexPath))
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions[section].title
    }
    
   override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let cell = sender as? TweetImageTableViewCell {
            return identifier == SegueIdentifier.Image
        }
        return false
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            
            switch identifier {
            case SegueIdentifier.Image:
                if let cell = sender as? TweetImageTableViewCell {
                    if let imageVC = segue.destinationViewController as? ImageViewController {
                        imageVC.imageURL = cell.imageURL
                    }
                }
            case SegueIdentifier.Web:
                if let webVC = segue.destinationViewController as? WebViewViewController {
                    if let cell = sender as? UITableViewCell {
                        webVC.webURL = NSURL(string: cell.textLabel!.text!)
                    }

                }
            case SegueIdentifier.Keyword:
                if let tweetVC = segue.destinationViewController as? TweetTableViewController {
                    if let cell = sender as? UITableViewCell {
                        tweetVC.searchText = cell.textLabel?.text
                    }
                }
            default: break
            }
        }
    }

}
