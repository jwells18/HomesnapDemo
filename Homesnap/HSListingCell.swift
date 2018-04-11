//
//  HSListingCell.swift
//  Homesnap
//
//  Created by Justin Wells on 3/24/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import SDWebImage

protocol ListingCellDelegate{
    func relayDidPressCell(cell: UICollectionViewCell)
    func relayDidPressSave(sender: UIButton)
    func relayDidPressMore(sender: UIButton)
}

class HSListingCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var listingCellDelegate: ListingCellDelegate!
    private var gradientView = UIView()
    private var gradient = CAGradientLayer()
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
    private var cellIdentifier = "cell"
    private var listings = [Listing]()
    private var listingImages = [String]()
    lazy var collectionView: UICollectionView = {
        //Setup CollectionView Flow Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        //Setup CollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = HSColor.faintGray
        collectionView.clipsToBounds = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Setup View
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setupView(){
        //Set Background Color
        self.backgroundColor = UIColor.white
        
        //Setup CollectionView
        collectionView.register(HSListingImageCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
        
        //Setup Gradient View 
        //Note: transparent view above collectionView is needed as sublayers are reused
        //Note: gradientView frame is fixed due to reuse cycles
        gradientView.frame = CGRect(x: 0, y: 0, width: w, height: w*0.6)
        gradientView.isUserInteractionEnabled = false
        self.addSubview(gradientView)
        
        //Add Gradient to CollectionView
        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor(white: 0.2, alpha: 0.8).cgColor]
        gradient.frame = gradientView.bounds
        gradientView.layer.insertSublayer(gradient, at: 0)
        
        //Setup ListingImages Count Label
        listingImagesCountLabel.textColor = UIColor.white
        listingImagesCountLabel.font = UIFont.systemFont(ofSize: 14)
        listingImagesCountLabel.textAlignment = .left
        listingImagesCountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(listingImagesCountLabel)
        
        //Setup Save Button
        scrollToBeginningButton.clipsToBounds = true
        scrollToBeginningButton.isHidden = true
        scrollToBeginningButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        scrollToBeginningButton.tintColor = UIColor.white
        scrollToBeginningButton.addTarget(self, action: #selector(self.scrollToBeginningButtonPressed), for: .touchUpInside)
        scrollToBeginningButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollToBeginningButton)
        
        //Setup Save Button
        saveButton.clipsToBounds = true
        saveButton.strokeColor = UIColor.white
        saveButton.tintColor = UIColor(white: 0.1, alpha: 0.5)
        saveButton.addTarget(self, action: #selector(self.saveButtonPressed), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(saveButton)
        
        //Setup More Button
        moreButton.clipsToBounds = true
        moreButton.setImage(UIImage(named: "moreVertical"), for: .normal)
        moreButton.tintColor = UIColor.white
        moreButton.addTarget(self, action: #selector(self.moreButtonPressed), for: .touchUpInside)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(moreButton)
        
        //Setup PriceLabel
        priceLabel.textColor = UIColor.white
        priceLabel.font = UIFont.boldSystemFont(ofSize: 22)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(priceLabel)
        
        //Setup Address Label
        addressLabel.textColor = UIColor.white
        addressLabel.font = UIFont.systemFont(ofSize: 14)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addressLabel)
        
        //Setup Bathroom Count Label
        bedroomCountLabel.textColor = UIColor.white
        bedroomCountLabel.font = UIFont.systemFont(ofSize: 14)
        bedroomCountLabel.textAlignment = .right
        bedroomCountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bedroomCountLabel)
        
        //Setup Bedroom Icon
        bedroomIcon.image = UIImage(named: "bedroom")
        bedroomIcon.clipsToBounds = true
        bedroomIcon.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bedroomIcon)
        
        //Setup Bathroom Count Label
        bathroomCountLabel.textColor = UIColor.white
        bathroomCountLabel.font = UIFont.systemFont(ofSize: 14)
        bathroomCountLabel.textAlignment = .right
        bathroomCountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bathroomCountLabel)
        
        //Setup Bathroom Icon
        bathroomIcon.image = UIImage(named: "bathroom")
        bathroomIcon.clipsToBounds = true
        bathroomIcon.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bathroomIcon)
        
        //Setup Sqft Label
        sqftLabel.textColor = UIColor.white
        sqftLabel.font = UIFont.systemFont(ofSize: 14)
        sqftLabel.textAlignment = .right
        sqftLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sqftLabel)
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupConstraints(){
        let spacerView = UIView()
        spacerView.isUserInteractionEnabled = false
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spacerView)
        
        let viewDict = ["collectionView": collectionView, "listingImagesCountLabel": listingImagesCountLabel,"scrollToBeginningButton": scrollToBeginningButton, "priceLabel": priceLabel, "addressLabel": addressLabel, "bedroomCountLabel": bedroomCountLabel, "bedroomIcon": bedroomIcon, "bathroomCountLabel": bathroomCountLabel, "bathroomIcon": bathroomIcon, "sqftLabel": sqftLabel, "saveButton": saveButton, "moreButton": moreButton, "spacerView": spacerView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[listingImagesCountLabel]-[scrollToBeginningButton(20)][spacerView][saveButton(25)]-[moreButton(25)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[priceLabel]-12-[bedroomCountLabel(<=30)]-6-[bedroomIcon(15)]-[bathroomCountLabel(<=30)]-6-[bathroomIcon(15)]-[sqftLabel]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[addressLabel]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[listingImagesCountLabel(25)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[spacerView(25)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[saveButton(25)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[moreButton(25)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[priceLabel(<=30)][addressLabel(18)]-2-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraint(NSLayoutConstraint.init(item: scrollToBeginningButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: listingImagesCountLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: bedroomCountLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: priceLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: bedroomIcon, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: priceLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: bathroomCountLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: priceLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: bathroomIcon, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: priceLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: sqftLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: priceLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: scrollToBeginningButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20))
        self.addConstraint(NSLayoutConstraint.init(item: bedroomCountLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 15))
        self.addConstraint(NSLayoutConstraint.init(item: bedroomIcon, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 15))
        self.addConstraint(NSLayoutConstraint.init(item: bathroomCountLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 15))
        self.addConstraint(NSLayoutConstraint.init(item: bathroomIcon, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 15))
        self.addConstraint(NSLayoutConstraint.init(item: sqftLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 15))
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        listingImagesCountLabel.sizeToFit()
        priceLabel.sizeToFit()
        bedroomCountLabel.sizeToFit()
        bathroomCountLabel.sizeToFit()
        sqftLabel.sizeToFit()
        collectionView.collectionViewLayout.invalidateLayout()
        self.setNeedsLayout()
    }
    
    func configure(listing: Listing?){
        if(listing?.images != nil){
            listingImages = (listing?.images!)!
        }
        listingImagesCountLabel.text = String(format: "%@ %@", String(listingImages.count), "photos".localized())
        self.collectionView.reloadData()
        
        if (listing?.price != nil){
            priceLabel.text = (listing?.price)!.currencyString(maxFractionDigits: 0)
        }
        else{
            priceLabel.text = "unavailable".localized()
        }
        
        bedroomCountLabel.text = (listing?.bedrooms)!.stringValue
        bathroomCountLabel.text = (listing?.bathrooms)!.stringValue
        sqftLabel.text = String(format: "%@ %@", (listing?.sqft)!.stringValue, "sqft")
        addressLabel.text = String(format: "%@ %@, %@, %@", (listing?.subThoroughfare)!,(listing?.thoroughfare)!,(listing?.locality)!,(listing?.administrativeArea)!)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        listingCellDelegate.relayDidPressCell(cell: self)
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
        let beginningIndexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: beginningIndexPath, at: UICollectionViewScrollPosition.left, animated: false)
    }
    
    func saveButtonPressed(sender:UIButton){
        listingCellDelegate.relayDidPressSave(sender: sender)
    }
    
    func moreButtonPressed(sender:UIButton){
        listingCellDelegate.relayDidPressMore(sender: sender)
    }
}
