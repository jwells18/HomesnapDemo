//
//  FeedItem.swift
//  Homesnap
//
//  Created by Justin Wells on 3/25/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation

class FeedItem: NSObject{
    
    var objectId: String!
    var createdAt: Date!
    var updatedAt: Date!
    var uid: String!
    var type: String!
    var title: String!
    var listings: [String]!
}
