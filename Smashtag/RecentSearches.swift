//
//  RecentSearches.swift
//  Smashtag
//
//  Created by Kunal Patel on 8/16/15.
//  Copyright (c) 2015 Kunal Patel. All rights reserved.
//

import Foundation

class RecentSearches {
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var searches: [String] {
        get {
            return defaults.objectForKey("RecentSearches.searches") as? [String] ?? []
        } set {
            defaults.setObject(newValue, forKey: "RecentSearches.searches")
        }
    }
    
    func addSearch(search: String) {
        var currentSearches = searches
        if let index = find(currentSearches, search) {
            currentSearches.removeAtIndex(index)
        }
        currentSearches.insert(search, atIndex: 0)
        while count(currentSearches) > 100 {
            currentSearches.removeLast()
        }
        searches = currentSearches
    }
    
    func removeSearch(atIndex index: Int) {
        var currentSearches = searches
        currentSearches.removeAtIndex(index)
        searches = currentSearches
    }
    
    
}