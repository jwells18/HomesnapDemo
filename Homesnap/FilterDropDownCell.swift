//
//  FilterDropDownCell.swift
//  Homesnap
//
//  Created by Justin Wells on 3/29/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class FilterDropDownCell: UITableViewCell{
    
    private var titleLabel = UILabel()
    private var detailLabel = UILabel()
    private var detailImage = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Setup View
        self.selectionStyle = .none
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        //Setup Title Label
        titleLabel.textColor = UIColor.darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        //Setup Detail Label
        detailLabel.text = "filterDefaultDetailText".localized()
        detailLabel.textColor = UIColor.lightGray
        detailLabel.font = UIFont.systemFont(ofSize: 16)
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(detailLabel)
        
        //Setup Accessory View
        detailImage.image = UIImage(named: "dropDown")
        detailImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(detailImage)
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupConstraints(){
        let spacerView = UIView()
        spacerView.isUserInteractionEnabled = false
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spacerView)
        
        let viewDict = ["titleLabel": titleLabel, "detailLabel": detailLabel, "detailImage": detailImage, "spacerView": spacerView] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLabel][spacerView]-2-[detailLabel]-2-[detailImage(15)]-15-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: detailLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: detailImage, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20))
        self.addConstraint(NSLayoutConstraint.init(item: detailLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 20))
        self.addConstraint(NSLayoutConstraint.init(item: detailImage, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 15))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Set Frames
        titleLabel.sizeToFit()
        detailLabel.sizeToFit()
    }
    
    func configure(title: String?){
        titleLabel.text = title
    }
}
