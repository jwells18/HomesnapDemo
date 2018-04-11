//
//  FeedController.swift
//  Homesnap
//
//  Created by Justin Wells on 3/23/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class FeedController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FeedItemCellDelegate{
    
    private let cellIdentifier = "cell"
    var feedItems = [FeedItem]()
    private var listingsDict = [String: Listing]()
    private var downloadingActivityView = UIActivityIndicatorView()
    private var isInitialDownload = true
    private var emptyCollectionView = UIView()
    private var refreshControl = UIRefreshControl()
    lazy var collectionView: UICollectionView = {
        //Setup CollectionView Flow Layout
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        
        //Setup CollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = HSColor.faintGray
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceVertical = true
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup NavigationBar
        self.setupNavigationBar()
        
        //Setup View
        self.setupView()
        
        //Download Data (prepared for pagination, but not implemented)
        self.downloadData(endDate: nil, refresh: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Show Navigation Bar
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        //Show Status Bar
        return false
    }
    
    //Setup NavigationBar
    func setupNavigationBar(){
        //Setup NavigationBar TitleView
        let navBarImageView = UIImageView(frame: CGRect(x: 0, y: 5, width:150, height: 34))
        navBarImageView.image = UIImage(named: "homesnapIcon2")
        navBarImageView.clipsToBounds = true
        navBarImageView.contentMode = .scaleAspectFit
        let navBarContainerView = UIView(frame: CGRect(x: 0, y: 0, width:150, height: 44))
        navBarContainerView.addSubview(navBarImageView)
        self.navigationItem.titleView = navBarContainerView
        
        //Set Navigation Items
        let cameraButton = UIBarButtonItem(image: UIImage(named: "camera"), style: .plain, target: self, action: #selector(cameraButtonPressed))
        self.navigationItem.leftBarButtonItem = cameraButton
    }
    
    //Download Data
    func downloadData(endDate: Date?, refresh: Bool){
        //Start Downloading ActivityView
        if isInitialDownload{
            downloadingActivityView.startAnimating()
        }
        
        //Change Initial Download Bool
        isInitialDownload = false
        
        //Download Feed Items
        let feedItemManager = FeedItemManager()
        feedItemManager.downloadFeed(uid: "user2") { (feedItems, error) in
            self.feedItems = feedItems!
            
            //TODO: Download Listings for FeedItems (not implemented in demo as Firebase Firestore does not allow queries using arrays
            //Realtime Database is a better alternative for the overall data structure since Firestore still lacks a few features (beta)
            //Local sample listings are used for demo purposes
            
            //Stop Downloading ActivityView
            if self.isInitialDownload{
                self.downloadingActivityView.stopAnimating()
            }
            
            //Show Empty View (if necessary)
            if self.feedItems.count > 0{
                self.collectionView.backgroundView = nil
            }
            else{
                self.collectionView.backgroundView = self.emptyCollectionView
            }
            
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    func refreshData(){
        self.downloadData(endDate: nil, refresh: true)
    }
    
    //Setup View
    func setupView(){
        //Set Background Color
        self.view.backgroundColor = HSColor.faintGray
        
        //Setup CollectionView
        self.setupCollectionView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupCollectionView(){
        //Register Cell for CollectionView
        collectionView.register(FeedItemCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.view.addSubview(collectionView)
        
        //Setup Downloading ActivityView
        downloadingActivityView.activityIndicatorViewStyle = .gray
        collectionView.backgroundView = downloadingActivityView
        
        //Setup RefreshControl
        refreshControl.tintColor = UIColor.lightGray
        refreshControl.layer.zPosition = -1
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        //Setup EmptyCollectionView
        let emptyCollectionViewLabel = UILabel(frame: CGRect(x: 0, y: 0, width: w, height: 250))
        emptyCollectionViewLabel.text = "emptyFeed".localized()
        emptyCollectionViewLabel.textColor = UIColor.lightGray
        emptyCollectionViewLabel.textAlignment = .center
        emptyCollectionViewLabel.font  = UIFont.boldSystemFont(ofSize: 22)
        emptyCollectionViewLabel.numberOfLines = 0
        emptyCollectionView.addSubview(emptyCollectionViewLabel)
    }
    
    func setupConstraints(){
        let viewDict = ["collectionView": collectionView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    override func viewWillLayoutSubviews() {
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    //CollectionView DataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.width, height: 390)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FeedItemCell
        cell.feedItemCellDelegate = self
        cell.configure(feedItem: feedItems[indexPath.item])
        
        return cell
    }
    
    //CollectionView Delegates
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Do not respond cell selections - (FeedItem collectionView handles callbacks)
    }
    
    func didPressFeedListingCell(indexPath: IndexPath?) {
        //Show Feature Unavailable
        self.present(featureUnavailableAlert(), animated: true, completion: nil)
    }
    
    func didPressSave(indexPath: IndexPath?) {
        //Show Feature Unavailable
        self.present(featureUnavailableAlert(), animated: true, completion: nil)
    }
    
    //BarButtonItem Delegate
    func cameraButtonPressed(){
        let cameraVC = CameraController()
        cameraVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(cameraVC, animated: true)
    }
}
