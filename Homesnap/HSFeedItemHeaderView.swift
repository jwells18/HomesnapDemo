//
//  HSFeedItemHeaderView.swift
//  Homesnap
//
//  Created by Justin Wells on 3/25/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import DateToolsSwift

class HSFeedItemHeaderView: UIView{
    
    private var feedItem: FeedItem!
    private var titleLabel =  UILabel()
    private var subTitleLabel1 = UILabel()
    private var subTitleLabel2 = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        //Setup View
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        //Setup Title Label
        titleLabel.textColor = UIColor(white: 0.2, alpha: 1)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        //Setup SubTitle1 Label
        subTitleLabel1.textColor = UIColor.lightGray
        subTitleLabel1.font = UIFont.systemFont(ofSize: 12)
        subTitleLabel1.numberOfLines = 0
        subTitleLabel1.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subTitleLabel1)
        
        //Setup SubTitle2 Label
        subTitleLabel2.textColor = UIColor.lightGray
        subTitleLabel2.font = UIFont.systemFont(ofSize: 12)
        subTitleLabel2.numberOfLines = 0
        subTitleLabel2.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subTitleLabel2)
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupConstraints(){
        //Setup Spacer Views
        let spacerViewTop = UIView()
        spacerViewTop.isUserInteractionEnabled = false
        spacerViewTop.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spacerViewTop)
        let spacerViewBottom = UIView()
        spacerViewBottom.isUserInteractionEnabled = false
        spacerViewBottom.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spacerViewBottom)
        
        let viewDict = ["titleLabel": titleLabel, "subTitleLabel1": subTitleLabel1, "subTitleLabel2": subTitleLabel2, "spacerViewTop": spacerViewTop, "spacerViewBottom": spacerViewBottom]
        //Set Horizontal Alignment
        self.addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: subTitleLabel1, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: subTitleLabel2, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: spacerViewTop, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: spacerViewBottom, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0))
        //Set Width
        self.addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 7/10, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: subTitleLabel1, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 7/10, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: subTitleLabel2, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 7/10, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: spacerViewTop, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 7/10, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: spacerViewBottom, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 7/10, constant: 0))
        //Set SpacerViews equal to each other
        self.addConstraint(NSLayoutConstraint.init(item: spacerViewTop, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: spacerViewBottom, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: spacerViewBottom, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: spacerViewTop, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0))
        //Set Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[spacerViewTop][titleLabel(<=75)][subTitleLabel1(<=14)][subTitleLabel2(<=14)][spacerViewBottom]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        subTitleLabel1.sizeToFit()
        subTitleLabel2.sizeToFit()
        self.setNeedsLayout()
    }
    
    func configure(feedItem: FeedItem?){
        if(feedItem?.title != nil){
            titleLabel.text = feedItem?.title
        }
        if(feedItem?.createdAt != nil){
            let date = (feedItem?.createdAt)!
            subTitleLabel1.text = date.timeAgoSinceNow
        }
    }
}
