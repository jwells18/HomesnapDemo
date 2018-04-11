//
//  ListingDetailController.swift
//  Homesnap
//
//  Created by Justin Wells on 3/25/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

protocol MapListingPopupDelegate{
    func didPressSave()
}

class ListingDetailController: HSPullupController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    private var cellIdentifier = "cell"
    var mapListingPopupDelegate: MapListingPopupDelegate!
    private var listing: Listing!
    private var listingImages = [String]()
    private var listingImagesCountLabel = UILabel()
    private var scrollToBeginningButton = UIButton()
    private var priceLabel = UILabel()
    private var addressLabel = UILabel()
    private var bedroomCountLabel = UILabel()
    private var bedroomIcon = UIImageView()
    private var bathroomCountLabel = UILabel()
    private var bathroomIcon = UIImageView()
    private var sqftLabel = UILabel()
    private var saveButton = HSSaveButton()
    private var moreButton = UIButton()
    lazy var collectionView: UICollectionView = {
        //Setup CollectionView Flow Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        
        //Setup CollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.backgroundColor = HSColor.faintGray
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup view
        self.view.backgroundColor = UIColor.white
        
        //Setup TableView
        self.setupView()
    }
    
    //Setup View
    func setupView(){
        self.view.backgroundColor = UIColor.white
        
        //Setup CollectionView
        collectionView.register(HSListingImageCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        //Setup ListingImages Count Label
        listingImagesCountLabel.textColor = UIColor.white
        listingImagesCountLabel.font = UIFont.systemFont(ofSize: 14)
        listingImagesCountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(listingImagesCountLabel)
        
        //Setup Save Button
        scrollToBeginningButton.clipsToBounds = true
        scrollToBeginningButton.isHidden = true
        scrollToBeginningButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        scrollToBeginningButton.tintColor = UIColor.white
        scrollToBeginningButton.addTarget(self, action: #selector(self.scrollToBeginningButtonPressed), for: .touchUpInside)
        scrollToBeginningButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollToBeginningButton)
        
        //Setup Save Button
        saveButton.clipsToBounds = true
        saveButton.strokeColor = UIColor.white
        saveButton.tintColor = UIColor(white: 0.1, alpha: 0.5)
        saveButton.addTarget(self, action: #selector(self.saveButtonPressed), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(saveButton)
        
        //Setup More Button
        moreButton.clipsToBounds = true
        moreButton.setImage(UIImage(named: "moreVertical"), for: .normal)
        moreButton.tintColor = UIColor.white
        moreButton.addTarget(self, action: #selector(self.moreButtonPressed), for: .touchUpInside)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(moreButton)
        
        //Setup PriceLabel
        priceLabel.textColor = UIColor.darkGray
        priceLabel.font = UIFont.boldSystemFont(ofSize: 22)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(priceLabel)
        
        //Setup Address Label
        addressLabel.textColor = UIColor.lightGray
        addressLabel.font = UIFont.systemFont(ofSize: 16)
        addressLabel.numberOfLines = 2
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addressLabel)
        
        //Setup Bathroom Count Label
        bedroomCountLabel.textColor = UIColor.darkGray
        bedroomCountLabel.font = UIFont.systemFont(ofSize: 16)
        bedroomCountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bedroomCountLabel)
        
        //Setup Bedroom Icon
        bedroomIcon.image = UIImage(named: "bedroomGray")
        bedroomIcon.clipsToBounds = true
        bedroomIcon.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bedroomIcon)
        
        //Setup Bathroom Count Label
        bathroomCountLabel.textColor = UIColor.darkGray
        bathroomCountLabel.font = UIFont.systemFont(ofSize: 16)
        bathroomCountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bathroomCountLabel)
        
        //Setup Bathroom Icon
        bathroomIcon.image = UIImage(named: "bathroomGray")
        bathroomIcon.clipsToBounds = true
        bathroomIcon.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bathroomIcon)
        
        //Setup Sqft Label
        sqftLabel.textColor = UIColor.darkGray
        sqftLabel.font = UIFont.systemFont(ofSize: 16)
        sqftLabel.textAlignment = .left
        sqftLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(sqftLabel)
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupConstraints(){
        let spacerView = UIView()
        spacerView.isUserInteractionEnabled = false
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(spacerView)
        
        let viewDict = ["collectionView": collectionView, "listingImagesCountLabel": listingImagesCountLabel,"scrollToBeginningButton": scrollToBeginningButton, "priceLabel": priceLabel, "addressLabel": addressLabel, "bedroomCountLabel": bedroomCountLabel, "bedroomIcon": bedroomIcon, "bathroomCountLabel": bathroomCountLabel, "bathroomIcon": bathroomIcon, "sqftLabel": sqftLabel, "saveButton": saveButton, "moreButton": moreButton, "spacerView": spacerView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[listingImagesCountLabel]-[scrollToBeginningButton(20)][spacerView][saveButton(25)]-[moreButton(25)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[priceLabel]-15-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[bedroomIcon(15)]-6-[bedroomCountLabel(<=30)]-16-[bathroomIcon(15)]-6-[bathroomCountLabel(<=30)]-16-[sqftLabel]-15-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[addressLabel]-15-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraint(NSLayoutConstraint.init(item: collectionView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: collectionView, attribute: NSLayoutAttribute.width, multiplier: 0.6, constant: 0))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[listingImagesCountLabel(25)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[spacerView(25)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[saveButton(25)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[moreButton(25)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]-15-[priceLabel(28)]-2-[bedroomCountLabel(20)]-2-[addressLabel(40)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraint(NSLayoutConstraint.init(item: scrollToBeginningButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: listingImagesCountLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: bedroomIcon, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: bedroomCountLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: bathroomCountLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: bedroomCountLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: bathroomIcon, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: bedroomCountLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: sqftLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: bedroomCountLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint.init(item: scrollToBeginningButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20))
        self.view.addConstraint(NSLayoutConstraint.init(item: bedroomIcon, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 15))
        self.view.addConstraint(NSLayoutConstraint.init(item: bathroomCountLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20))
        self.view.addConstraint(NSLayoutConstraint.init(item: bathroomIcon, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 15))
        self.view.addConstraint(NSLayoutConstraint.init(item: sqftLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //Set Frame
        listingImagesCountLabel.sizeToFit()
        priceLabel.sizeToFit()
        bedroomCountLabel.sizeToFit()
        bathroomCountLabel.sizeToFit()
        sqftLabel.sizeToFit()
        self.view.setNeedsLayout()
        
        //Add Shadow
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.9
    }
    
    func configure(listing: Listing?) {
        if(listing?.images != nil){
            listingImages = (listing?.images!)!
        }
        listingImagesCountLabel.text = String(format: "%@ %@", String(listingImages.count), "photos".localized())
        self.collectionView.reloadData()
        self.scrollToFirstItem()

        
        if (listing?.price != nil){
            priceLabel.text = (listing?.price)!.currencyString(maxFractionDigits: 0)
        }
        else{
            priceLabel.text = "unavailable".localized()
        }
        
        bedroomCountLabel.text = (listing?.bedrooms)!.stringValue
        bathroomCountLabel.text = (listing?.bathrooms)!.stringValue
        sqftLabel.text = String(format: "%@ %@", (listing?.sqft)!.stringValue, "sqft")
        addressLabel.text = String(format: "%@ %@\n%@, %@", (listing?.subThoroughfare)!,(listing?.thoroughfare)!,(listing?.locality)!,(listing?.administrativeArea)!)
    }
    
    //CollectionView DataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listingImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Setup Listing CollectionView
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HSListingImageCell
        let listingImage = listingImages[indexPath.item]
        cell.configure(image: listingImage)
        return cell
    }
    
    //ScrollView Delegates
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Determine whether to show ScrollToBeginningButton
        let indexPath = collectionView.indexPathForItem(at: CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y))
        if((indexPath?.item ?? 0)! > 1){
            scrollToBeginningButton.isHidden = false
        }
        else{
            scrollToBeginningButton.isHidden = true
        }
    }
    
    //Button Delegates
    func scrollToBeginningButtonPressed(sender:UIButton){
        self.scrollToFirstItem()
    }
    
    func scrollToFirstItem(){
        let beginningIndexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: beginningIndexPath, at: UICollectionViewScrollPosition.left, animated: false)
    }
    
    func saveButtonPressed(sender:UIButton){
        //Save Listing
        //Show Feature Unavailable
        self.present(featureUnavailableAlert(), animated: true, completion: nil)
    }
    
    func moreButtonPressed(sender:UIButton){
        //Show More
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alertAction) in
            //Save
            //Show Feature Unavailable
            self.present(featureUnavailableAlert(), animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Message", style: .default, handler: { (alertAction) in
            //Message
            //Show Feature Unavailable
            self.present(featureUnavailableAlert(), animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { (alertAction) in
            //Share
            //Show Feature Unavailable
            self.present(featureUnavailableAlert(), animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.popoverPresentationController?.sourceView = sender
        alert.popoverPresentationController?.sourceRect = CGRect(x: sender.frame.width/2, y: sender.frame.height, width: CGFloat(1), height: CGFloat(1))
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        self.present(alert, animated: true, completion: nil)
    }
    
    //PullUpController Functions
    override var pullUpControllerPreferredSize: CGSize {
        return CGSize(width: w, height: w*0.6+124)
    }
    
    override var pullUpControllerPreviewOffset: CGFloat {
        return w*0.6+124
    }
    
    override var pullUpControllerMiddleStickyPoints: [CGFloat] {
        return []
    }
    
    override var pullUpControllerIsBouncingEnabled: Bool {
        return false
    }
    
    override var pullUpControllerPreferredLandscapeFrame: CGRect {
        return CGRect(x: 0, y: h-35-(h*0.6+124), width: 2
            , height: h*0.6+124)
    }
    
    override var dismissableHeight: CGFloat{
        return (w*0.6)/2
    }
    
    override var isDismissable: Bool{
        return true
    }
}


