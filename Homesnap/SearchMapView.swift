//
//  SearchMapView.swift
//  Homesnap
//
//  Created by Justin Wells on 3/23/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import MapKit
import Segmentio

class SearchMapView: UIView{
    
    var mapView = MKMapView()
    var mapViewTypeButton: HSMapViewButton!
    var mapViewNearbyButton: HSMapViewButton!
    var bottomNavViewLine: CALayer!
    var segmentioView: Segmentio!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        //Setup View
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        //Set Background Color
        self.backgroundColor = UIColor.white
        
        //Setup SegmentioView
        self.setupSegmentioView()
        
        //Setup MapView
        self.setupMapView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupSegmentioView(){
        //Setup SegmentedItems
        let segmentedItems = self.setupSegmentedItems()
        let segmentedOptions = SegmentioOptions(
            backgroundColor: .white,
            segmentPosition: .fixed(maxVisibleItems: 3),
            scrollEnabled: false,
            indicatorOptions: nil,
            horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions.init(type: .none),
            verticalSeparatorOptions: SegmentioVerticalSeparatorOptions.init(ratio: 0),
            labelTextAlignment: .center,
            segmentStates: SegmentioStates(
                defaultState: SegmentioState(
                    backgroundColor: .white,
                    titleFont: UIFont.systemFont(ofSize: 16),
                    titleTextColor: HSColor.primary
                ),
                selectedState: SegmentioState(
                    backgroundColor: .white,
                    titleFont: UIFont.systemFont(ofSize: 16),
                    titleTextColor: HSColor.primary
                ),
                highlightedState: SegmentioState(
                    backgroundColor: .white,
                    titleFont: UIFont.systemFont(ofSize: 16),
                    titleTextColor: HSColor.primary
                )
            )
        )
        //Setup SegmentedControl
        segmentioView = Segmentio(frame: CGRect.zero)
        segmentioView.translatesAutoresizingMaskIntoConstraints = false
        segmentioView.selectedSegmentioIndex = 0
        segmentioView.setup(
            content: segmentedItems,
            style: .onlyLabel,
            options: segmentedOptions
        )
        self.addSubview(segmentioView)
        
        //Add SegmentioView hairline
        bottomNavViewLine = CALayer()
        bottomNavViewLine.backgroundColor = UIColor.lightGray.cgColor
        segmentioView.layer.addSublayer(bottomNavViewLine)
    }
    
    func setupSegmentedItems() -> [SegmentioItem]{
        var segmentedItems = [SegmentioItem]()
        for index in stride(from: 0, to: searchMapSegmentedTitles.count, by:1) {
            let item = SegmentioItem(
                title: searchMapSegmentedTitles[index],
                image: nil
            )
            segmentedItems.append(item)
        }
        return segmentedItems
    }
    
    func setupMapView(){
        //Setup MapView
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mapView)
        
        //Set Sample Location (Potomac, MD)
        let location = CLLocation(latitude: 39.0134888038227, longitude: -77.1809593472444)
        
        //Setup Region
        var region = MKCoordinateRegion()
        region.center.latitude = location.coordinate.latitude;
        region.center.longitude = location.coordinate.longitude;
        region.span.latitudeDelta = 0.15
        region.span.longitudeDelta = 0.15
        mapView.setRegion(region, animated: false)
        
        //Setup MapViewType Button
        mapViewTypeButton = HSMapViewButton(frame: CGRect.zero)
        mapViewTypeButton.translatesAutoresizingMaskIntoConstraints = false
        mapViewTypeButton.setTitle("map".localized(), for: .normal)
        mapViewTypeButton.setImage(UIImage(named:"mapDefault"), for: .normal)
        mapView.addSubview(mapViewTypeButton)
        
        //Setup MapViewNearby Button
        mapViewNearbyButton = HSMapViewButton(frame: CGRect.zero)
        mapViewNearbyButton.translatesAutoresizingMaskIntoConstraints = false
        mapViewNearbyButton.setTitle("nearby".localized(), for: .normal)
        mapViewNearbyButton.setImage(UIImage(named:"nearby"), for: .normal)
        mapView.addSubview(mapViewNearbyButton)
    }
    
    func setupConstraints(){
        let viewDict = ["segmentioView": segmentioView, "mapView": mapView, "mapViewTypeButton": mapViewTypeButton, "mapViewNearbyButton": mapViewNearbyButton] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentioView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.mapView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[mapViewTypeButton(50)]-5-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.mapView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[mapViewNearbyButton(50)]-5-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[segmentioView(34.5)]-0.5-[mapView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.mapView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[mapViewTypeButton(50)]-10-[mapViewNearbyButton(50)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Set Frames
        bottomNavViewLine.frame = CGRect(x: 0, y: 34.5, width: segmentioView.frame.width, height: 0.5)
    }
    
    func configure(){
        
    }
}
