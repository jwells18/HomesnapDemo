//
//  HSPlacemark.swift
//  Homesnap
//
//  Created by Justin Wells on 3/29/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation
import MapKit

public enum PlacemarkType{
    case listing
    case school
    case shopAndEat
}

class HSPlacemark: NSObject{
    var type: PlacemarkType!
    var coordinate: CLLocationCoordinate2D!
    
    override init(){
        super.init()
    }
}
