//
//  TabBarController.swift
//  WalkieTalkie
//
//  Created by Justin Wells on 3/23/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        self.delegate = self
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.tintColor = HSColor.primary
    }
}
