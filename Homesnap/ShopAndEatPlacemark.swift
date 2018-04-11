//
//  ShopAndEatPlacemark.swift
//  Homesnap
//
//  Created by Justin Wells on 3/29/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation
import MapKit

private enum category: String{
    case restaurant
    case shopping
    case activeLife
    case nightLife
    case grocery
    case cafe
    case artsAndEntertainment
    case beautyAndSpas
}

class ShopAndEatPlacemark: HSPlacemark{
    
    var name: String!
    var placemark: MKPlacemark!
    var isCurrentLocation = false
    var phoneNumber: String!
    var url: URL!
    var timeZone: TimeZone!
    
    init(mapItem: MKMapItem){
        super.init()
        self.type = .shopAndEat
        self.coordinate = mapItem.placemark.coordinate
        self.name = mapItem.name
        self.placemark = mapItem.placemark
        self.isCurrentLocation = mapItem.isCurrentLocation
        self.phoneNumber = mapItem.phoneNumber
        self.url = mapItem.url
        self.timeZone = mapItem.timeZone
    }
}


