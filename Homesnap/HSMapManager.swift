//
//  HSMapManager.swift
//  Homesnap
//
//  Created by Justin Wells on 3/27/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import MapKit

class HSMapManager: NSObject{
    
    func mapLocalSearch(string: String, region: MKCoordinateRegion, completionHandler:@escaping ([HSMapAnnotation]) -> Void){
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = string
        request.region = region
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start(completionHandler: { (response, error) in
            var annotations = [HSMapAnnotation]()
            
            for mapItem in (response?.mapItems)!{
                //For each mapItem create a custom map data class (HSMapItem)
                let customMapItem = HSMapItem(mapItem: mapItem, searchString: string)
                //Create annotation for each custom map data item
                let annotation = self.createAnnotation(item: customMapItem)
                annotations.append(annotation)
            }
            
            //Return annotations to add to map and HSMapItems 
            completionHandler(annotations)
        })
    }
    
    func queryListings(region: MKCoordinateRegion, completionHandler:@escaping ([HSMapAnnotation], [Listing]) -> Void){
        //Query for Listings in the region (Firestore Geopoint queries are not available yet, but will have native support in the future)
        //Using sample data in interim for demo purposes
        //GeoFire and Firebase Realtime Database is another alternative
        let listingItem0 = createSampleListing0()
        let listingItem1 = createSampleListing1()
        let listingItem2 = createSampleListing2()
        let listings = [listingItem0, listingItem1, listingItem2]
        //Loop through listings and create annotation for each listing
        var annotations = [HSMapAnnotation]()
        
        for listing in listings{
            //For each listing create a custom map data class (HSMapItem)
            let customMapItem = HSMapItem(listing: listing)
            //Create annotation for each custom map data item
            let annotation = self.createAnnotation(item: customMapItem)
            annotations.append(annotation)
        }
        //Return annotations to add to map and HSMapItem
        completionHandler(annotations, listings)
    }
    
    func createAnnotation(item: HSMapItem) -> HSMapAnnotation{
        //Create Annotation based on mapItem data
        let annotation = HSMapAnnotation(placemark: item.placemark)
        return annotation
    }
    
}
