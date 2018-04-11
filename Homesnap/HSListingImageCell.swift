//
//  HSListingImageCell.swift
//  Homesnap
//
//  Created by Justin Wells on 3/27/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import SDWebImage

class HSListingImageCell: UICollectionViewCell{
    
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Set Background Color
        backgroundColor = HSColor.faintGray
        
        //Setup ImageView
        self.setupImageView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImageView(){
        //Setup ImageView
        contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.backgroundColor = HSColor.faintGray
        contentView.addSubview(imageView)
    }
    
    func setupConstraints(){
        let viewDict = ["imageView": imageView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Set Frames
    }
    
    func configure(image: String?){
        //Set ImageView Image
        if (image != nil){
            imageView.sd_setImage(with: URL(string: image!), placeholderImage: nil)
        }
        else{
            imageView.image = nil
        }
    }
}
