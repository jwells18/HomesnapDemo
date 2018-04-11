//
//  SpotCrime.swift
//  Homesnap
//
//  Created by Justin Wells on 3/26/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class SpotCrime: NSObject{
    
    var baseUrl = "http://api.spotcrime.com/crimes.json"
    var key = "privatekeyforspotcrimepublicusers-commercialuse-877.410.1607"
    
    func getCrimes(location: CLLocationCoordinate2D, radius: Float){
        let qs = ["lat": location.latitude, "lon": location.longitude, "key": key, "radius": radius] as [String : Any]
        let parameters: Parameters = ["url": baseUrl, "json": true, "qs": qs]
        
        Alamofire.request(baseUrl, method: .get,parameters: parameters).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
        }
    }
}
