//
//  ListingPlacemark.swift
//  Homesnap
//
//  Created by Justin Wells on 3/29/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation
import MapKit

private enum category: String{
    case forSale
    case forRent
    case recentlySold
}

class ListingPlacemark: HSPlacemark{
    
    var listing: Listing!
    
    init(listing: Listing){
        super.init()
        self.type = .listing
        self.coordinate = CLLocationCoordinate2D(latitude: listing.latitude.doubleValue, longitude: listing.longitude.doubleValue)
        self.listing = listing
    }
}
