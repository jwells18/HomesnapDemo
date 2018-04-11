//
//  HSListingAnnotationView.swift
//  Homesnap
//
//  Created by Justin Wells on 3/29/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation
import MapKit

class HSAnnotationView: MKAnnotationView{
    
    var listingMarker = UIButton()
    var text: String?
    var marker = UIButton()
    var mapAnnotation: HSMapAnnotation!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        //Setup marker
        self.setupMarker()
        
        //Setup listingLabel
        self.setupListingLabel()
        
        //Setup AnnotationView
        self.mapAnnotation = annotation as! HSMapAnnotation
        let placemark = mapAnnotation.placemark
        let type = (placemark?.type)!
        switch type{
        case .school:
            marker.backgroundColor = UIColor.orange
            marker.isHidden = false
            listingMarker.isHidden = true
            self.canShowCallout = true
            self.frame = marker.frame
            break
        case .shopAndEat:
            marker.backgroundColor = UIColor.red
            marker.isHidden = false
            listingMarker.isHidden = true
            self.canShowCallout = true
            self.frame = marker.frame
            break
        case .listing:
            listingMarker.isHidden = false
            marker.isHidden = true
            self.canShowCallout = true
            listingMarker.sizeToFit()
            self.frame = listingMarker.frame
            break
        }
    }
    
    override var annotation: MKAnnotation? {
        willSet{
            if annotation != nil{
                self.mapAnnotation = annotation as! HSMapAnnotation
                let placemark = mapAnnotation.placemark
                let type = (placemark?.type)!
                switch type{
                case .school:
                    marker.backgroundColor = UIColor.orange
                    marker.isHidden = false
                    listingMarker.isHidden = true
                    self.canShowCallout = true
                    self.frame = marker.frame
                    break
                case .shopAndEat:
                    marker.backgroundColor = UIColor.red
                    marker.isHidden = false
                    listingMarker.isHidden = true
                    self.canShowCallout = true
                    self.frame = marker.frame
                    break
                case .listing:
                    listingMarker.isHidden = false
                    marker.isHidden = true
                    self.canShowCallout = false
                    listingMarker.setTitle(self.mapAnnotation.title ?? "", for: .normal)
                    listingMarker.sizeToFit()
                    self.frame = listingMarker.frame
                    break
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMarker(){
        marker.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        marker.layer.borderWidth = 2
        marker.layer.borderColor = UIColor.white.cgColor
        marker.layer.cornerRadius = marker.frame.width/2
        marker.clipsToBounds = true
        marker.backgroundColor = UIColor.lightGray
        marker.isHidden = true
        marker.isUserInteractionEnabled = false
        self.addSubview(marker)
    }
    
    func setupListingLabel(){
        listingMarker.frame = CGRect(x: 0, y: 0, width: 75, height: 20)
        listingMarker.setTitleColor(UIColor.white, for: .normal)
        listingMarker.titleLabel?.textAlignment = .center
        listingMarker.layer.cornerRadius = 3
        listingMarker.clipsToBounds = true
        listingMarker.backgroundColor = HSColor.primary
        listingMarker.isHidden = true
        listingMarker.isUserInteractionEnabled = false
        self.addSubview(listingMarker)
    }
}
