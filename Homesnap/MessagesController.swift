//
//  MessagesController.swift
//  Homesnap
//
//  Created by Justin Wells on 3/23/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class MessagesController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup NavigationBar
        self.setupNavigationBar()
        
        //Setup View
        self.setupView()
    }
    
    func setupNavigationBar(){
        //Setup Navigation Title
        self.navigationItem.title = "messagesTabTitle".localized()
    }
    
    func setupView(){
        //Set Background Color
        self.view.backgroundColor = HSColor.faintGray
        
        //Set Hire Me Label
        self.view = createHireMeBackgroundView()
    }
}
