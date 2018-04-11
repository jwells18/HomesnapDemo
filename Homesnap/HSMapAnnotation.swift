//
//  HSMapAnnotation.swift
//  Homesnap
//
//  Created by Justin Wells on 3/29/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation
import MapKit

class HSMapAnnotation: NSObject, MKAnnotation{
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var placemark: HSPlacemark!
    var type: PlacemarkType!
    
    init(placemark: HSPlacemark) {
        self.coordinate = placemark.coordinate
        self.placemark = placemark
        self.type = placemark.type
        switch type!{
        case .school:
            let schoolPlacemark = placemark as! SchoolPlacemark
            self.title = schoolPlacemark.name
            break
        case .shopAndEat:
            let shopAndEatPlacemark = placemark as! ShopAndEatPlacemark
            self.title = shopAndEatPlacemark.name
            break
        case .listing:
            let listingPlacemark = placemark as! ListingPlacemark
            //Show shorter currency version
            self.title = listingPlacemark.listing.price.shortCurrencyString()
            break
        }
        
        super.init()
    }
}
