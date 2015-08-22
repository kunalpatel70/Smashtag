//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Kunal Patel on 8/10/15.
//  Copyright (c) 2015 Kunal Patel. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate
{
    
    var tweets = [[Tweet]]()
    var searchText: String? = "#drawing" {
        didSet {
            lastSuccessfulRequest = nil
            searchTextField?.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    var lastSuccessfulRequest: TwitterRequest?
    
    var nextReqeustToAttempt: TwitterRequest? {
        if lastSuccessfulRequest == nil {
            if var query = searchText {
                if query.hasPrefix("@") {
                    return TwitterRequest(search: "\(query) OR from:\(query)", count: 100)
                } else {
                    return TwitterRequest(search: searchText!, count: 100)
                }
            } else {
                return nil
            }
        } else {
            return lastSuccessfulRequest!.requestForNewer
        }
    }
    
    func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        if searchText != nil {
            RecentSearches().addSearch(searchText!)
            if let request = nextReqeustToAttempt {
                request.fetchTweets { (newTweets) -> Void in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        if newTweets.count > 0 {
                            self.tweets.insert(newTweets, atIndex: 0)
                            self.tableView.reloadData()
                            sender?.endRefreshing()
                        }
                    }
                }
            }
        } else {
            sender?.endRefreshing()
        }
    }

    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }
    
    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tweets[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseIdentifier.Tweet, forIndexPath: indexPath) as! TweetTableViewCell

        // Configure the cell...
        cell.tweet = tweets[indexPath.section][indexPath.row]

        return cell
    }
    
    @IBAction func goBack(segue: UIStoryboardSegue) {
        println("Someone unwound back to me!");
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            if identifier == "showDetailSegue" {
                if let cell = sender as? TweetTableViewCell {
                    if let tweetDetailVC = segue.destinationViewController as? MentionsTableViewController {
                        tweetDetailVC.tweet = cell.tweet
                    }
                }
            }
        }
    }
    

}
