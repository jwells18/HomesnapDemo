//
//  FeedItemCell.swift
//  Homesnap
//
//  Created by Justin Wells on 3/23/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import SDWebImage

protocol FeedItemCellDelegate{
    func didPressFeedListingCell(indexPath: IndexPath?)
    func didPressSave(indexPath: IndexPath?)
}

class FeedItemCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FeedItemListingCellDelegate{
    
    var feedItemCellDelegate: FeedItemCellDelegate!
    private var cellIdentifier = "cell"
    private var listings = [Listing]()
    private var headerView = HSFeedItemHeaderView()
    lazy var collectionView: UICollectionView = {
        //Setup CollectionView Flow Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        
        //Setup CollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.clipsToBounds = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Setup View
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setupView(){
        //Setup HeaderView
        self.addSubview(headerView)
        
        //Setup CollectionView
        collectionView.register(FeedItemListingCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.clipsToBounds = true
        collectionView.layer.cornerRadius = 5
        self.addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Set Frames
        headerView.frame = CGRect(x: 15, y: 15, width: frame.size.width-30, height: 75)
        collectionView.frame = CGRect(x: 0, y: 95, width: frame.size.width, height: 280)
    }
    
    func configure(feedItem: FeedItem?){
        if (feedItem != nil){
            //Setup HeaderView
            headerView.configure(feedItem: feedItem)
            
            //Setup CollectionView 
            //Note: Using sample data for demo purposes
            //listings = feedItem!.listings
            if feedItem?.objectId == "kRm8L1whihBWhRxhysKq"{
                //Bethesda
                let listingItem0 = createSampleListing2()
                listings = [listingItem0]
            }
            else if feedItem?.objectId == "MgT22ksXyeG4DOGszGF9"{
                //Potomac
                let listingItem0 = createSampleListing0()
                let listingItem1 = createSampleListing1()
                listings = [listingItem0, listingItem1]
            }
            
            collectionView.reloadData()
        }
    }
    
    //CollectionView DataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.height*0.85, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FeedItemListingCell
        cell.feedItemListingCellDelegate = self
        let listing = listings[indexPath.item]
        let listingImage = listing.images.first 
        cell.configure(listing: listing, image: listingImage)
        return cell
    }
    
    //CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        feedItemCellDelegate.didPressFeedListingCell(indexPath: indexPath)
    }
    
    //CollectionViewCell Delegate
    func relayDidPressSave(sender: UIButton){
        let touchPoint = sender.convert(CGPoint.zero, to: collectionView)
        let indexPath = collectionView.indexPathForItem(at: touchPoint)
        feedItemCellDelegate.didPressSave(indexPath: indexPath)
    }
}
