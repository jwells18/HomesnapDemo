//
//  FilterListingsFooterView.swift
//  Homesnap
//
//  Created by Justin Wells on 3/25/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

protocol FilterListingsFooterViewDelegate{
    func didPressFooterView()
}

class FilterListingsFooterView: UIButton{
    
    var filterListingsFooterViewDelegate: FilterListingsFooterViewDelegate!
    var moreFiltersLabel = UILabel()
    var moreFiltersIcon = UIImageView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        //Setup View
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        //Add Target to View
        self.addTarget(self, action: #selector(self.footerViewPressed), for: .touchUpInside)
        
        //Add Top Separator Line
        let topSeparatorLine = CALayer()
        topSeparatorLine.frame = CGRect(x: 0, y: 0, width: w, height: 0.5)
        topSeparatorLine.backgroundColor = HSColor.faintGray.cgColor
        self.layer.addSublayer(topSeparatorLine)
        
        //Setup More Filters Label
        moreFiltersLabel.text = "moreFilters".localized()
        moreFiltersLabel.textColor = UIColor.darkGray
        moreFiltersLabel.textAlignment = .center
        moreFiltersLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(moreFiltersLabel)
        
        //Setup More Filters Icon
        moreFiltersIcon.image = UIImage(named: "dropDown")
        moreFiltersIcon.clipsToBounds = true
        moreFiltersIcon.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(moreFiltersIcon)
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupConstraints(){
        let spacerViewLeft = UIView()
        spacerViewLeft.isUserInteractionEnabled = false
        spacerViewLeft.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spacerViewLeft)
        
        let spacerViewRight = UIView()
        spacerViewRight.isUserInteractionEnabled = false
        spacerViewRight.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spacerViewRight)
        
        let viewDict = ["moreFiltersLabel": moreFiltersLabel, "moreFiltersIcon": moreFiltersIcon, "spacerViewLeft": spacerViewLeft, "spacerViewRight": spacerViewRight] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[spacerViewLeft][moreFiltersLabel(<=150)]-2-[moreFiltersIcon(15)][spacerViewRight]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraint(NSLayoutConstraint.init(item: spacerViewLeft, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: spacerViewRight, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 30))
        //Height & Vertical Alignment
        self.addConstraint(NSLayoutConstraint.init(item: moreFiltersLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: moreFiltersIcon, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: moreFiltersLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: moreFiltersLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25))
        self.addConstraint(NSLayoutConstraint.init(item: moreFiltersIcon, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 15))
        self.addConstraint(NSLayoutConstraint.init(item: spacerViewLeft, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: spacerViewRight, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Set Frames
        moreFiltersLabel.sizeToFit()
    }
    
    func footerViewPressed(){
        self.filterListingsFooterViewDelegate.didPressFooterView()
    }
}
