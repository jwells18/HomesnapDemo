//
//  ListingManager.swift
//  Homesnap
//
//  Created by Justin Wells on 3/31/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import Firebase

class ListingManager: NSObject{
    
    func downloadListings(ids: [String], completionHandler:@escaping ([Listing]?, Error?) -> Void){
        db.collection(listingDatabase).whereField("objectId", isEqualTo: ids)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completionHandler(nil, err)
                } else {
                    var listings = [Listing]()
                    for document in querySnapshot!.documents {
                        //Create Listing
                        let listing = self.createListing(rawData: document.data())
                        listings.insert(listing, at: 0)
                    }
                    completionHandler(listings, nil)
                }
        }
    }
    
    func createListing(rawData: [String: Any]) -> Listing{
        let listing = Listing()
        listing.objectId = rawData["objectId"] as! String
        listing.createdAt = rawData["createdAt"] as! Date
        listing.updatedAt = rawData["updatedAt"] as! Date
        listing.latitude = rawData["latitude"] as! NSNumber
        listing.longitude = rawData["longitude"] as! NSNumber
        listing.subThoroughfare = rawData["subThoroughfare"] as! String
        listing.thoroughfare = rawData["thoroughfare"] as! String
        listing.locality = rawData["locality"] as! String
        listing.administrativeArea = rawData["administrativeArea"] as! String
        listing.country = rawData["country"] as! String
        listing.postalCode = rawData["postalCode"] as! String
        listing.price = rawData["price"] as! NSNumber
        listing.isPriceDifferent = rawData["isPriceDifferent"] as! Bool
        listing.previousPrice = rawData["previousPrice"] as! NSNumber
        listing.bedrooms = rawData["bedrooms"] as! NSNumber
        listing.bathrooms = rawData["bathrooms"] as! NSNumber
        listing.sqft = rawData["bathrooms"] as! NSNumber
        listing.sqftLotSize = rawData["bathrooms"] as! NSNumber
        listing.buildDate = rawData["buildDate"] as! Date
        listing.detailedDescription = rawData["detailedDescription"] as! String!
        listing.images = rawData["images"] as! [String]!
        listing.createdBy = rawData["createdBy"] as! String!
        
        return listing
    }
}
