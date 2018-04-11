//
//  FeedListingCell.swift
//  Homesnap
//
//  Created by Justin Wells on 3/23/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import SDWebImage

protocol FeedItemListingCellDelegate{
    func relayDidPressSave(sender: UIButton)
}

class FeedItemListingCell: UICollectionViewCell{
    
    var feedItemListingCellDelegate: FeedItemListingCellDelegate!
    private var imageView = UIImageView()
    private var priceLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var addressLabel = UILabel()
    private var statusLabel = UILabel()
    private var saveButton = HSSaveButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Setup View
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setupView(){
        //Set Background Color & Border
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 1
        self.layer.borderColor = HSColor.faintGray.cgColor
        
        //Setup ImageView
        imageView.backgroundColor = HSColor.faintGray
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        
        //Setup PriceLabel
        priceLabel.textColor = UIColor.darkGray
        priceLabel.font = UIFont.boldSystemFont(ofSize: 20)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(priceLabel)
        
        //Setup Description Label
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 1
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(descriptionLabel)
        
        //Setup Address Label1
        addressLabel.textColor = UIColor.lightGray
        addressLabel.font = UIFont.systemFont(ofSize: 14)
        addressLabel.numberOfLines = 2
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addressLabel)
        
        //Setup Status Label
        statusLabel.textColor = UIColor.green
        statusLabel.numberOfLines = 1
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(statusLabel)
        
        //Setup Save Button
        saveButton.clipsToBounds = true
        saveButton.strokeColor = UIColor.white
        saveButton.tintColor = UIColor(white: 0.1, alpha: 0.5)
        saveButton.addTarget(self, action: #selector(self.saveButtonPressed), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(saveButton)
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupConstraints(){
        let viewDict = ["imageView": imageView, "priceLabel": priceLabel, "descriptionLabel": descriptionLabel, "addressLabel": addressLabel, "statusLabel": statusLabel, "saveButton": saveButton] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-1-[imageView]-1-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[priceLabel]-15-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[descriptionLabel]-15-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[addressLabel]-15-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[statusLabel]-15-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[saveButton(25)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-1-[imageView(150)]-15-[priceLabel(<=30)]-3-[descriptionLabel(<=20)]-3-[addressLabel(<=40)]-3-[statusLabel(<=20)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[saveButton(25)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Set Frames
        priceLabel.sizeToFit()
        descriptionLabel.sizeToFit()
        addressLabel.sizeToFit()
        statusLabel.sizeToFit()
        self.setNeedsLayout()
    }
    
    func configure(listing: Listing?, image: String?){
        if(image != nil){
            imageView.sd_setImage(with: URL(string: image!), placeholderImage: nil)
        }
        
        if (listing?.price != nil){
            priceLabel.text = NSNumber(value: Int((listing?.price)!)).currencyString(maxFractionDigits: 0)
        }
        else{
            priceLabel.text = "unavailable".localized()
        }
        
        descriptionLabel.text = String(format:"%@ %@  %@ %@  %@ sqft", (listing?.bedrooms)!.stringValue,"bedroomAbbreviation".localized(), (listing?.bathrooms)!.stringValue,"bathroomAbbreviation".localized(), (listing?.sqft)!.stringValue)
        addressLabel.text = String(format: "%@ %@\n%@, %@ %@", (listing?.subThoroughfare)!,(listing?.thoroughfare)!,(listing?.locality)!,(listing?.administrativeArea)!, (listing?.postalCode)!)
    }
    
    //Button Delegates
    func saveButtonPressed(sender:UIButton){
        feedItemListingCellDelegate.relayDidPressSave(sender: sender)
    }
}
