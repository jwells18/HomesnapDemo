//
//  HSMapItem.swift
//  Homesnap
//
//  Created by Justin Wells on 3/27/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import MapKit

enum type: String{
    case listing
    case school
    case shopAndEat
}

class HSMapItem: NSObject{

    fileprivate var type: type!
    var coordinate: CLLocationCoordinate2D!
    var placemark: HSPlacemark!
    
    init(mapItem: MKMapItem, searchString: String) {
        super.init()
        switch searchString{
        case "schools":
            self.type = .school
            self.coordinate = mapItem.placemark.coordinate
            self.placemark = SchoolPlacemark(mapItem: mapItem)
            break
        case "restaurants":
            self.type = .shopAndEat
            self.coordinate = mapItem.placemark.coordinate
            self.placemark = ShopAndEatPlacemark(mapItem: mapItem)
            break
        default:
            break
        }
    }
    
    init(listing: Listing) {
        super.init()
        self.type = .listing
        self.coordinate = CLLocationCoordinate2D(latitude: listing.latitude.doubleValue, longitude: listing.longitude.doubleValue)
        self.placemark = ListingPlacemark(listing: listing)
    }
}
