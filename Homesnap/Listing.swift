//
//  Listing.swift
//  Homesnap
//
//  Created by Justin Wells on 3/23/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation

class Listing: NSObject{
    var objectId: String!
    var createdAt: Date!
    var updatedAt: Date!
    var latitude: NSNumber!
    var longitude: NSNumber!
    var subThoroughfare: String! //Street Number
    var thoroughfare: String! //Street
    var locality: String! //City
    var administrativeArea: String! //State
    var country: String! //Country
    var postalCode: String!//Zip Code
    var price: NSNumber!
    var isPriceDifferent: Bool!
    var previousPrice: NSNumber!
    var bedrooms: NSNumber!
    var bathrooms: NSNumber!
    var sqft: NSNumber!
    var sqftLotSize: NSNumber!
    var buildDate: Date!
    var detailedDescription: String!
    var images: [String]!
    var createdBy: String!
}
