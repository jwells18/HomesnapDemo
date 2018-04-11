//
//  HSMapViewButton.swift
//  Homesnap
//
//  Created by Justin Wells on 3/24/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class HSMapViewButton: UIButton{
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        //Setup View
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        //Setup Button
        self.backgroundColor = UIColor.init(white: 1, alpha: 0.9)
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        self.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        self.contentHorizontalAlignment = .center
        self.contentVerticalAlignment = .top
        
        //Set ImageView
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 7, 14, 7)
        
        //Setup Title Label
        self.setTitleColor(UIColor.darkGray, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        self.titleEdgeInsets = UIEdgeInsetsMake(26, -26, 0, 0)
    }
}
