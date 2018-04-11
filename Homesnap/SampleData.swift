//
//  SampleData.swift
//  Homesnap
//
//  Created by Justin Wells on 4/1/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation

//Sample Data
func createSampleListing0() -> Listing{
    let sampleListing = Listing()
    sampleListing.objectId = "a1b2c3d4"
    sampleListing.createdAt = NSNumber(value: 1520222655407).dateValue()
    sampleListing.updatedAt = NSNumber(value: 1520222655407).dateValue()
    sampleListing.latitude = 39.0554393
    sampleListing.longitude = -77.22190119999999
    sampleListing.subThoroughfare = "10700" //Street Number
    sampleListing.thoroughfare = "Red Barn Ln" //Street
    sampleListing.locality = "Potomac" //City
    sampleListing.administrativeArea = "MD" //State
    sampleListing.country = "United States" //Country
    sampleListing.postalCode = "20854" //Zip Code
    sampleListing.price = 4449000
    sampleListing.isPriceDifferent = false
    sampleListing.previousPrice = 4449000
    sampleListing.bedrooms = 6
    sampleListing.bathrooms = 8
    sampleListing.sqft = 7194
    sampleListing.sqftLotSize = 174240
    sampleListing.buildDate = NSNumber(value: 1520222655407).dateValue()
    sampleListing.detailedDescription = "Undeniably the most spectacular custom home in Potomac. Strategically situated in prestigious High Gate, the curb appeal offers a blend of English Charm & Nantucket Character. The home has been transformed throughout with the conversion to contemporary sophistication. Main home, guest quarters, pool house, fitness center, salt-water fountain pool, Car Collector's Space, endless serene views."
    sampleListing.images = ["https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSample1.jpg?alt=media&token=62bc4182-8b31-436a-95ed-4a4d6dd33a14", "https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSample2.jpg?alt=media&token=ce63659b-8b3b-46d4-9a30-b62ac1963117","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSample3.jpg?alt=media&token=81c42fac-c969-4993-9150-89e4cb4a8666","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSample4.jpg?alt=media&token=cd919d07-04ab-4c84-b313-22db068631b4","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSample5.jpg?alt=media&token=ecfd687e-56d4-401a-bf00-d823ed06163b","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSample7.jpg?alt=media&token=86668b88-ab8f-4b5e-a0b7-0903c440093e","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSample8.jpg?alt=media&token=f68f74c4-cde4-488e-a469-b91d37cd7b11","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSample9.jpg?alt=media&token=fb0a720d-2e97-4e2a-885e-8fd63ef7b93a","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSample10.jpg?alt=media&token=95a4697b-ec5c-461f-af33-00c4f6af9499","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSample11.jpg?alt=media&token=22cc9353-182c-4fea-a66e-e2e51aefc84d"]
    sampleListing.createdBy = "aabbccddee"
    
    return sampleListing
}

func createSampleListing1() -> Listing{
    let sampleListing = Listing()
    sampleListing.objectId = "a1b2c3d4"
    sampleListing.createdAt = NSNumber(value: 1520222655407).dateValue()
    sampleListing.updatedAt = NSNumber(value: 1520222655407).dateValue()
    sampleListing.latitude = 39.0190809
    sampleListing.longitude = -77.19232360000001
    sampleListing.subThoroughfare = "10017" //Street Number
    sampleListing.thoroughfare = "Bentcross Dr" //Street
    sampleListing.locality = "Potomac" //City
    sampleListing.administrativeArea = "MD" //State
    sampleListing.country = "United States" //Country
    sampleListing.postalCode = "20854" //Zip Code
    sampleListing.price = 4400000
    sampleListing.isPriceDifferent = false
    sampleListing.previousPrice = 4400000
    sampleListing.bedrooms = 6
    sampleListing.bathrooms = 9
    sampleListing.sqft = 10710
    sampleListing.sqftLotSize = 9226.833 //meters
    sampleListing.buildDate = NSNumber(value: 1520222655407).dateValue()
    sampleListing.detailedDescription = "A serene wooded lot provides the backdrop for this world-class contemporary home in Potomac's premier neighborhood of Falconhurst. Built in 1990, 10017 Bentcross has undergone extensive renovations to form a seamless blend of luxurious interior living and immaculate outdoor entertainment space. Soaring ceilings and endless walls of windows create a sundrenched floor plan that flows effortlessly outside to an unparalleled hardscape backyard, making this an entertainer's absolute dream home. A gated circular drive leads to the front entrance of this bespoke three-level residence, featuring 6 bedrooms, 6 full and 3 half baths across 10,710 square feet of living space."
    sampleListing.images = ["https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSampleA1.jpg?alt=media&token=81a3c356-9502-4fa4-8a2b-3f9c9ea794ab","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSampleA2.jpg?alt=media&token=253cefe4-e754-4cf1-8acc-5189a91bdf20","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSampleA3.jpg?alt=media&token=fcab2665-daf7-4447-974a-0bfd5c32c612","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSampleA4.jpg?alt=media&token=6e94f866-1082-46c4-bb65-a13f3009e976","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSampleA5.jpg?alt=media&token=5487c819-768d-41af-96aa-ff4bcd8411aa","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSampleA6.jpg?alt=media&token=19f10285-e30b-4377-b516-b4c0920d503c","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSampleA7.jpg?alt=media&token=ecde763b-1436-44d8-a266-b1b9dd0056e9","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSampleA8.jpg?alt=media&token=6f0e5961-d203-463c-9e11-ea5ea83870e2","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSampleA9.jpg?alt=media&token=ccc2dcd8-59c9-48e8-bed6-d92d21e19ca9"]
    sampleListing.createdBy = "aabbccddee"
    
    return sampleListing
}

func createSampleListing2() -> Listing{
    let sampleListing = Listing()
    sampleListing.objectId = "a1b2c3d4"
    sampleListing.createdAt = NSNumber(value: 1520222655407).dateValue()
    sampleListing.updatedAt = NSNumber(value: 1520222655407).dateValue()
    sampleListing.latitude = 38.9979976
    sampleListing.longitude = -77.13512380000003
    sampleListing.subThoroughfare = "6600" //Street Number
    sampleListing.thoroughfare = "Lybrook Ct" //Street
    sampleListing.locality = "Bethesda" //City
    sampleListing.administrativeArea = "MD" //State
    sampleListing.country = "United States" //Country
    sampleListing.postalCode = "20817" //Zip Code
    sampleListing.price = 4495000
    sampleListing.isPriceDifferent = false
    sampleListing.previousPrice = 4495000
    sampleListing.bedrooms = 6
    sampleListing.bathrooms = 10
    sampleListing.sqft = 12315
    sampleListing.sqftLotSize = 4208.731
    sampleListing.buildDate = NSNumber(value: 1520222655407).dateValue()
    sampleListing.detailedDescription = "This exquisite custom built one of a kind home was constructed by and for the current owners and reflects the pride of ownership rarely found in today's market. A traditional floorplan featuring embassy sized informal and formal rooms creates an environment ideal for large scale entertaining and comfortable family living. From the breathtaking two-story entry foyer with extraordinary staircase, to the stunning gourmet chef's kitchen with adjoining expansive family room, to the deluxe master bedroom suite complete with sitting area and luxury bath, no detail has been compromised in presenting this fine home of distinction."
    sampleListing.images = ["https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSampleB1.jpg?alt=media&token=5c7572c8-e1f9-4d54-ac4d-a7d7bada87d9","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSampleB2.jpg?alt=media&token=4e43d602-8a7a-47d1-991e-55dde3b9b4cd","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSampleB3.jpg?alt=media&token=38e37682-6465-43e8-8796-003ac966f603","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSampleB4.jpg?alt=media&token=faedfa5d-61b3-4d38-81fd-826100d699e2","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSampleB5.jpg?alt=media&token=3b731ab7-1d36-4003-9597-727036407cbf","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSampleB6.jpg?alt=media&token=4b7a581e-18f0-4571-b209-553dd11cbc2c","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSampleB7.jpg?alt=media&token=9062a82d-3afb-4d31-ae6a-bdaa555a65de","https://firebasestorage.googleapis.com/v0/b/homesnap-d99f3.appspot.com/o/HomesnapSampleB8.jpg?alt=media&token=8084c238-87d7-416b-ad94-7d5fba6d2aaf"]
    sampleListing.createdBy = "aabbccddee"
    
    return sampleListing
}

func createSampleFeedItem() -> FeedItem{
    let feedItem = FeedItem()
    feedItem.createdAt = NSNumber(value: 1520222655407).dateValue()
    feedItem.title = "4 New Listings in North Bethesda, MD"
    feedItem.listings = ["a1b2c3d4"]
    feedItem.objectId = "a11b22c333"
    
    return feedItem
}
