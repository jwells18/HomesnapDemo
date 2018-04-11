//
//  SearchListView.swift
//  Homesnap
//
//  Created by Justin Wells on 3/23/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import Segmentio

protocol SearchListViewDelegate{
    func didPressCell(indexPath: IndexPath?)
    func didPressSave(indexPath: IndexPath?)
    func didPressMore(sender:UIButton)
}

class SearchListView: UIView, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, ListingCellDelegate{
    
    var searchListViewDelegate: SearchListViewDelegate!
    var cellIdentifier = "cell"
    var segmentioView: Segmentio!
    var bottomNavViewLine: CALayer!
    var listings: [Listing]!
    lazy var collectionView: UICollectionView = {
        //Setup CollectionView Flow Layout
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        
        //Setup CollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = HSColor.faintGray
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceVertical = true
        
        return collectionView
    }()
    
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
        
        //Setup SegmentedControl
        self.setupSegmentioView()
        
        //Setup CollectionView
        self.setupCollectionView()
    }
    
    func setupSegmentioView(){
        //Setup SegmentedItems
        segmentioView = Segmentio(frame: CGRect.zero)
        segmentioView.selectedSegmentioIndex = 0
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
        //Setup SegmentioView
        segmentioView.setup(
            content: segmentedItems,
            style: .onlyLabel,
            options: segmentedOptions
        )
        
        //Add SegmentioView hairline
        bottomNavViewLine = CALayer()
        bottomNavViewLine.backgroundColor = UIColor.lightGray.cgColor
        segmentioView.layer.addSublayer(bottomNavViewLine)
    }
    
    func setupSegmentedItems() -> [SegmentioItem]{
        var segmentedItems = [SegmentioItem]()
        for index in stride(from: 0, to: searchListSegmentedTitles.count, by:1) {
            let item = SegmentioItem(
                title: searchListSegmentedTitles[index],
                image: nil
            )
            segmentedItems.append(item)
        }
        return segmentedItems
    }
    
    func setupCollectionView(){
        //Register Cell for CollectionView
        collectionView.register(HSListingCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.addSubview(collectionView)
    }
    
    func configure(listings: [Listing]?){
        if(listings != nil){
            self.listings = listings
        }
        else{
            self.listings = nil
        }
        
        self.collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Add SegmentioView 
        //TODO: Titles only appear when segmentioView is added in layoutSubviews (Find better solution)
        self.addSubview(segmentioView)
        //Set Frames
        segmentioView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 34.5)
        bottomNavViewLine.frame = CGRect(x: 0, y: 34.5, width: segmentioView.frame.width, height: 0.5)
        collectionView.frame = CGRect(x: 0, y: 35, width: frame.width, height: h-navigationHeaderAndStatusbarHeight-35)
    }
    
    //CollectionView DataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (listings?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width*0.6)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Setup Listing CollectionView
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HSListingCell
        cell.listingCellDelegate = self
        let listing = listings[indexPath.item]
        cell.configure(listing: listing)
        return cell
    }
    
    //CollectionViewCell Delegate
    func relayDidPressCell(cell: UICollectionViewCell){
        let indexPath = collectionView.indexPath(for: cell)
        searchListViewDelegate.didPressCell(indexPath: indexPath)
    }
    
    func relayDidPressSave(sender: UIButton){
        let touchPoint = sender.convert(CGPoint.zero, to: collectionView)
        let indexPath = collectionView.indexPathForItem(at: touchPoint)
        searchListViewDelegate.didPressSave(indexPath: indexPath)
    }
    
    func relayDidPressMore(sender: UIButton){
        searchListViewDelegate.didPressMore(sender: sender)
    }
}
