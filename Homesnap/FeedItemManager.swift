//
//  FeedItemManager.swift
//  Homesnap
//
//  Created by Justin Wells on 3/25/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import Firebase

class FeedItemManager: NSObject{
    
    func downloadFeed(uid: String?, completionHandler:@escaping ([FeedItem]?, Error?) -> Void){
        db.collection(feedItemDatabase).whereField("uid", isEqualTo: "user1")
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completionHandler(nil,  error)
                } else {
                    var feedItems = [FeedItem]()
                    for document in querySnapshot!.documents {
                        //Create FeedItem
                        let feedItem = self.createFeedItem(rawData: document.data())
                        feedItems.insert(feedItem, at: 0)
                    }
                    completionHandler(feedItems, nil)
                }
        }
    }
    
    func createFeedItem(rawData: [String: Any]) -> FeedItem{
        let feedItem = FeedItem()
        feedItem.objectId = rawData["objectId"] as! String
        feedItem.createdAt = rawData["createdAt"] as! Date
        feedItem.updatedAt = rawData["updatedAt"] as! Date
        feedItem.type = rawData["type"] as! String
        feedItem.uid = rawData["uid"] as! String
        feedItem.title = rawData["title"] as! String
        feedItem.listings = rawData["listings"] as! [String]
        
        return feedItem
    }
}
