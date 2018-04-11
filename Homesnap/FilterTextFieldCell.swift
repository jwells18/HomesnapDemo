//
//  FilterTextFieldCell.swift
//  Homesnap
//
//  Created by Justin Wells on 3/29/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class FilterTextFieldCell: UITableViewCell{
    
    private var titleLabel = UILabel()
    private var textField = UITextField()
    
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
        
        //Setup SegmentedControl
        textField.textColor = UIColor.darkGray
        textField.tintColor = HSColor.primary
        textField.layer.borderWidth = 1
        textField.layer.borderColor = HSColor.faintGray.cgColor
        textField.layer.cornerRadius = 3
        textField.clipsToBounds = true
        textField.placeholder = "filterTextFieldPlaceholder".localized()
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupConstraints(){
        let viewDict = ["titleLabel": titleLabel, "textField": textField] as [String : Any]
        //Width & Horizontal Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLabel]-15-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[textField]-15-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[titleLabel(20)]-4-[textField(34)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Set Frames
    }
    
    func configure(title: String?){
        titleLabel.text = title
    }
}
