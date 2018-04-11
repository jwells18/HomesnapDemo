//
//  Constants.swift
//  WalkieTalkie
//
//  Created by Justin Wells on 3/23/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

//View Dimensions
let screenBounds = UIScreen.main.bounds
let screenSize   = screenBounds.size
let w = screenSize.width
let h = screenSize.height

//UIObject Dimensions
let navigationHeight: CGFloat = 44.0
let statusBarHeight: CGFloat = 20.0
let navigationHeaderAndStatusbarHeight : CGFloat = navigationHeight + statusBarHeight
let tabBarHeight: CGFloat = 49.0
let searchBarFontSize = CGFloat(16)

//Custom Colors
struct HSColor{
    static let primary = UIColorFromRGB(0x3A88C7)
    static let secondary = UIColorFromRGB(0x5856d6)
    static let faintGray = UIColor(white: 0.95, alpha: 1)
}

public func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

//Arrays
var searchMapSegmentedTitles = ["localInfo".localized(), "saveSearch".localized(), "list".localized()]
var searchListSegmentedTitles = ["sort".localized(), "saveSearch".localized(), "map".localized()]
var filterListingsSegmentedTitles = ["forSale".localized(), "forRent".localized()]
var filterOptionsSegmentedTitles = ["priceRange".localized(), "beds".localized(), "keywords".localized()]
var filterBedBathSegmentedTitles = ["any".localized(), "1+", "2+", "3+", "4+", "5+"]
var localInfoSegmentedTitles = ["crime".localized(), "schools".localized(), "shopAndEat".localized(), "priceTrends".localized(), "people".localized(), "liveWell".localized()]
var localInfoSegmentedImages: [UIImage] = [UIImage(named: "crime")!, UIImage(named: "schools")!, UIImage(named: "shopAndEat")!, UIImage(named: "priceTrends")!, UIImage(named: "people")!, UIImage(named: "liveWell")!]
var localInfoSegmentedSelectedImages: [UIImage] = [UIImage(named: "crimeS")!, UIImage(named: "schoolsS")!, UIImage(named: "shopAndEatS")!, UIImage(named: "priceTrendsS")!, UIImage(named: "peopleS")!, UIImage(named: "liveWellS")!]

//Database
var feedItemDatabase = "FeedItem"
var listingDatabase = "Listing"

//HireMe Label
func createHireMeBackgroundView() -> UIView{
    let hireMeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: h-navigationHeaderAndStatusbarHeight-tabBarHeight))
    hireMeLabel.text = "Hire me to make more cool stuff \u{1F60E}"
    hireMeLabel.textColor = UIColor.lightGray
    hireMeLabel.backgroundColor = HSColor.faintGray
    hireMeLabel.textAlignment = .center
    hireMeLabel.font = UIFont.boldSystemFont(ofSize: 30)
    hireMeLabel.numberOfLines = 0
    
    return hireMeLabel
}

//Feature Not Available
public func featureUnavailableAlert() -> UIAlertController{
    //Show Alert that this feature is not available
    let alert = UIAlertController(title: NSLocalizedString("Sorry", comment:""), message: NSLocalizedString("This feature is not available yet.", comment:""), preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    return alert
}

//Helper Functions
public func currentTimestamp() -> Double{
    let timestamp = Date().timeIntervalSince1970*1000
    return Double(timestamp)
}

extension NSNumber{
    
    func currencyString(maxFractionDigits: Int) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = maxFractionDigits
        let currencyString = formatter.string(from: self)
        
        return currencyString!
    }
    
    func shortCurrencyString() -> String {
        let formatter = NumberFormatter()
        
        typealias Abbrevation = (threshold:Double, divisor:Double, suffix:String)
        let abbreviations:[Abbrevation] = [(0, 1, ""),
                                           (1000.0, 1000.0, "K"),
                                           (100_000.0, 1_000_000.0, "M"),
                                           (100_000_000.0, 1_000_000_000.0, "B")]
        
        let startValue = abs(self.doubleValue)
        let abbreviation:Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if (startValue < tmpAbbreviation.threshold) {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        } ()
        
        let value = self.doubleValue / abbreviation.divisor
        formatter.positiveSuffix = abbreviation.suffix
        formatter.negativeSuffix = abbreviation.suffix
        formatter.allowsFloats = true
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .currency
        
        return formatter.string(from: NSNumber(value: value))!
    }
    
    func dateValue() -> Date {
        let timeInterval: TimeInterval = self.doubleValue
        let date = Date.init(timeIntervalSince1970: timeInterval/1000)
        
        return date
    }
}

