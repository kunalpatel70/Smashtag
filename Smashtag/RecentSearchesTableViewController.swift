//
//  RecentSearchesTableViewController.swift
//  Smashtag
//
//  Created by Kunal Patel on 8/16/15.
//  Copyright (c) 2015 Kunal Patel. All rights reserved.
//

import UIKit

class RecentSearchesTableViewController: UITableViewController {


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentSearches().searches.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseIdentifier.History, forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = RecentSearches().searches[indexPath.row]
        return cell
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            RecentSearches().removeSearch(atIndex: indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == SegueIdentifier.SearchHistory {
                if let cell = sender as? UITableViewCell {
                    if let tweetVC = segue.destinationViewController as? TweetTableViewController {
                        tweetVC.searchText = cell.textLabel?.text
                    }
                }
            }
        }
    }
    

}
