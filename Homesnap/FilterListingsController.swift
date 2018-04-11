//
//  FilterListingsController.swift
//  Homesnap
//
//  Created by Justin Wells on 3/24/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

class FilterListingsController: UIViewController, UITableViewDataSource, UITableViewDelegate, FilterListingsFooterViewDelegate{
    
    private var tableView: UITableView!
    private var dropDownCellIdentifier = "dropDownCell"
    private var segmentedCellIdentifier = "segmentedCell"
    private var textFieldCellIdentifier = "textFieldCell"
    private var isInitialLoad = true
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //Setup NavigationBar
        self.setupNavigationBar()
        
        //Setup View
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Show Toolbar
        self.navigationController?.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Hide Toolbar
        self.navigationController?.isToolbarHidden = true
    }
    
    //Setup NavigationBar
    func setupNavigationBar(){
        //Setup Navigation Title
        self.navigationItem.title = "filter".localized()
        
        //Setup Navigation Items
        let backButton = UIBarButtonItem(image: UIImage(named: "cancel"), style: .plain, target: self, action: #selector(self.backButtonPressed))
        self.navigationItem.leftBarButtonItem = backButton
        let applyFilterButton = UIBarButtonItem(title: "apply".localized(), style: .plain, target: self, action: #selector(self.applyFilterButtonPressed))
        self.navigationItem.rightBarButtonItem = applyFilterButton
        
        //Remove Gray Hairline
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //Setup Bottom NavigationBar
        self.setupBottomNavBar()
        
        //Setup Navigation Toolbar
        self.setupNavToolbar()
    }
    
    func setupBottomNavBar(){
        //Setup Container View
        let bottomNavBar = UIView(frame: CGRect(x: 0, y: 0, width: w, height: 43.5))
        bottomNavBar.backgroundColor = UIColor.white
        
        //Setup SegmentedControl
        let segmentedControl = UISegmentedControl(items: filterListingsSegmentedTitles)
        segmentedControl.frame = CGRect(x: 15, y: 8, width: w-30, height: 28)
        segmentedControl.tintColor = HSColor.primary
        segmentedControl.selectedSegmentIndex = 0
        bottomNavBar.addSubview(segmentedControl)
        
        //Add navigationBar hairline
        let bottomNavViewLine = CALayer()
        bottomNavViewLine.frame = CGRect(x: 0, y: 43.5, width: w, height: 0.5)
        bottomNavViewLine.backgroundColor = UIColor.lightGray.cgColor
        bottomNavBar.layer.addSublayer(bottomNavViewLine)
        self.view.addSubview(bottomNavBar)
    }
    
    func setupNavToolbar(){
        self.navigationController?.toolbar.tintColor = UIColor.darkGray
        
        //Setup Navigation Toolbar
        let resetButton = UIBarButtonItem(title: "reset".localized(), style: .plain, target: self, action: #selector(self.resetButtonPressed))
        //Add Save Search Button
        let saveSearchIconButton = UIBarButtonItem(image: UIImage(named:"saveSearch"), style: .plain, target: self, action: #selector(self.saveSearchButtonPressed))
        let saveSearchButton = UIBarButtonItem(title: "saveSearch".localized(), style: .plain, target: self, action: #selector(self.saveSearchButtonPressed))
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolbarItems = [resetButton, flexibleSpaceItem, flexibleSpaceItem, flexibleSpaceItem,saveSearchIconButton,saveSearchButton]
        
        self.navigationController?.toolbar.sizeToFit()
        self.navigationController?.toolbar.barTintColor = UIColor.white
        self.setToolbarItems(toolbarItems, animated: false)
    }
    
    //Setup View
    func setupView(){
        //Set Background Color
        self.view.backgroundColor = HSColor.faintGray
        
        //Setup TableView
        self.setupTableView()
        
        //Setup TapToResign Gesture Recognizer
        self.setupTapToResignGestureRecognizer()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupTableView(){
        //Setup TableView
        tableView = UITableView(frame: CGRect(x:0, y:44, width:w, height:h-44), style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = HSColor.faintGray
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = true
        tableView.register(FilterDropDownCell.self, forCellReuseIdentifier: dropDownCellIdentifier)
        tableView.register(FilterSegmentedCell.self, forCellReuseIdentifier: segmentedCellIdentifier)
        tableView.register(FilterTextFieldCell.self, forCellReuseIdentifier: textFieldCellIdentifier)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(tableView)
    }
    
    func setupTapToResignGestureRecognizer(){
        let tapToResignGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.resignTextFields))
        tapToResignGestureRecognizer.numberOfTapsRequired = 1
        tapToResignGestureRecognizer.numberOfTouchesRequired = 1
        tapToResignGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapToResignGestureRecognizer)
    }
    
    func setupConstraints(){
        let viewDict = ["tableView": tableView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    //UITableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInitialLoad{
            return 3
        }
        else{
            return filterOptionsSegmentedTitles.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isInitialLoad{
            return 50
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = FilterListingsFooterView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        footerView.filterListingsFooterViewDelegate = self
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.row){
        case 0:
            //Price Range
            let cell = tableView.dequeueReusableCell(withIdentifier: dropDownCellIdentifier, for: indexPath) as! FilterDropDownCell
            cell.configure(title: "priceRange".localized())
            return cell
        case 1:
            //Beds
            let cell = tableView.dequeueReusableCell(withIdentifier: segmentedCellIdentifier, for: indexPath) as! FilterSegmentedCell
            cell.configure(title: "beds".localized())
            return cell
        case 2:
            //Keywords
            let cell = tableView.dequeueReusableCell(withIdentifier: textFieldCellIdentifier, for: indexPath) as! FilterTextFieldCell
            cell.configure(title: "keywords".localized())
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: dropDownCellIdentifier, for: indexPath) as! FilterSegmentedCell
            return cell
        }
    }
    
    //CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            //Price Range
            //Show Feature Unavailable
            self.present(featureUnavailableAlert(), animated: true, completion: nil)
            break
        case 1:
            //Beds
            break
        case 2:
            //Keywords
            break
        default:
            break
        }
    }
    
    //Footer Delegate
    func didPressFooterView(){
        //Show Feature Unavailable
        self.present(featureUnavailableAlert(), animated: true, completion: nil)
    }
    
    //Gesture Recognizer Delegate
    func resignTextFields(sender: UITapGestureRecognizer){
        if (sender.state == .ended){
            //Resign all textFields
            self.view.endEditing(true)
        }
    }

    //BarButtonItem Delegate
    func backButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func applyFilterButtonPressed(){
        //Show Feature Unavailable
        self.present(featureUnavailableAlert(), animated: true, completion: nil)
    }
    
    func resetButtonPressed(){
        //Show Feature Unavailable
        self.present(featureUnavailableAlert(), animated: true, completion: nil)
    }
    
    func saveSearchButtonPressed(){
        //Show Feature Unavailable
        self.present(featureUnavailableAlert(), animated: true, completion: nil)
    }
}
