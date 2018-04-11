//
//  LocalInfoController.swift
//  Homesnap
//
//  Created by Justin Wells on 3/24/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import Segmentio

class LocalInfoController: HSPullupController, UITableViewDataSource, UITableViewDelegate{

    var cellIdentifier = "cell"
    var segmentioView = Segmentio()
    var cancelButton = UIButton()
    var tableView = UITableView()
    var drawerBar = UIView()
    //var crimes = [Crimes]()
    var schoolPlacemarks = [SchoolPlacemark]()
    var shopAndEatPlacemarks = [ShopAndEatPlacemark]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        //Setup View
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Show Navigation Bar
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        //Show Status Bar
        return false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //Round Edges
        view.layer.cornerRadius = 12
        cancelButton.layer.cornerRadius = cancelButton.frame.width/2
    }
    
    func setupView(){
        //Add Drawer Bar
        self.setupDrawerBar()
        
        //Add Cancel Button
        self.setupCancelButton()
        
        //Setup SegmentioView
        self.setupSegmentioView()
        
        //Setup TableView
        self.setupTableView()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupDrawerBar(){
        drawerBar.translatesAutoresizingMaskIntoConstraints = false
        drawerBar.backgroundColor = HSColor.faintGray
        drawerBar.layer.cornerRadius = 2
        self.view.addSubview(drawerBar)
    }
    
    func setupCancelButton(){
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(UIImage(named: "cancel"), for: .normal)
        cancelButton.backgroundColor = HSColor.faintGray
        cancelButton.layer.cornerRadius = cancelButton.frame.width/2
        cancelButton.clipsToBounds = true
        self.view.addSubview(cancelButton)
    }
    
    func setupSegmentioView(){
        //Setup SegmentedItems
        let segmentedItems = self.setupSegmentedItems()
        let segmentedOptions = SegmentioOptions(
            backgroundColor: .white,
            segmentPosition: .dynamic,
            scrollEnabled: true,
            indicatorOptions: SegmentioIndicatorOptions.init(type: SegmentioIndicatorType.bottom, ratio: 0.75, height: 2, color: HSColor.primary),
            horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions.init(type: .none),
            verticalSeparatorOptions: SegmentioVerticalSeparatorOptions.init(ratio: 0),
            imageContentMode: .center,
            labelTextAlignment: .center
        )
        
        //Setup SegmentioView
        segmentioView.translatesAutoresizingMaskIntoConstraints = false
        segmentioView.selectedSegmentioIndex = 0
        segmentioView.setup(
            content: segmentedItems,
            style: .imageOverLabel,
            options: segmentedOptions
        )

        view.addSubview(segmentioView)
    }
    
    func setupSegmentedItems() -> [SegmentioItem]{
        var segmentedItems = [SegmentioItem]()
        for index in stride(from: 0, to: localInfoSegmentedTitles.count, by:1) {
            let item = SegmentioItem(
                title: localInfoSegmentedTitles[index],
                image: localInfoSegmentedImages[index],
                selectedImage: localInfoSegmentedSelectedImages[index]
            )
            segmentedItems.append(item)
        }
        return segmentedItems
    }
    
    func setupTableView(){
        //Setup TableView
        tableView = UITableView(frame: CGRect(x:0, y:115, width:w, height:self.pullUpControllerPreviewOffset-115), style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = true
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(tableView)
    }
    
    func setupConstraints(){
        let viewDict = ["drawerBar": drawerBar, "cancelButton": cancelButton, "segmentioView": segmentioView, "tableView": tableView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraint(NSLayoutConstraint.init(item: drawerBar, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40))
        self.view.addConstraint(NSLayoutConstraint.init(item: drawerBar, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[cancelButton(25)]-5-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[segmentioView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[drawerBar(4)]-21-[segmentioView(80)]-5-[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[cancelButton(25)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    //Configure Data
    func configure(schoolAnnotations: [HSMapAnnotation]){
        for annotation in schoolAnnotations{
            let placemark = annotation.placemark as! SchoolPlacemark
            schoolPlacemarks.append(placemark)
        }
        tableView.reloadData()
    }
    
    func configure(shopAndEatAnnotations: [HSMapAnnotation]){
        for annotation in shopAndEatAnnotations{
            let placemark = annotation.placemark as! ShopAndEatPlacemark
            shopAndEatPlacemarks.append(placemark)
        }
        tableView.reloadData()
    }
    
    func resetData(){
        schoolPlacemarks.removeAll()
        shopAndEatPlacemarks.removeAll()
        tableView.reloadData()
    }
    
    //TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentioView.selectedSegmentioIndex{
        case 0:
            //Crimes
            return 0//crimes.count
        case 1:
            //Schools
            return schoolPlacemarks.count
        case 2:
            //ShopAndEat
            return shopAndEatPlacemarks.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch segmentioView.selectedSegmentioIndex{
        case 0:
            //Crimes
            return 25
        case 1:
            //Schools
            return 25
        case 2:
            //ShopAndEat
            return 25
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height:25))
        headerView.backgroundColor = UIColor.white
        
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.width-30, height:25))
        headerLabel.textColor = UIColor.darkGray
        headerLabel.font = UIFont.systemFont(ofSize: 14)
        switch(segmentioView.selectedSegmentioIndex){
        case 0:
            headerLabel.text = String(format: "%@ %@:","0","localInfoCrimeHeader".localized())
            break
        case 1:
            headerLabel.text = String(format: "%@ %@:",String(schoolPlacemarks.count),"localInfoSchoolHeader".localized())
            break
        case 2:
            headerLabel.text = String(format: "%@ %@:",String(shopAndEatPlacemarks.count),"localInfoLocationHeader".localized())
            break
        default:
            headerLabel.text = ""
            break
        }
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell") 
        cell?.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell?.textLabel?.textColor = UIColor.darkGray
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.detailTextLabel?.textColor = UIColor.lightGray
        cell?.selectionStyle = .none
        switch segmentioView.selectedSegmentioIndex{
        case 0:
            //Crimes
            cell?.textLabel?.text = ""
            return cell!
        case 1:
            //Schools
            let schoolPlacemark = schoolPlacemarks[indexPath.row]
            cell?.textLabel?.text = schoolPlacemark.name
            let placemark = schoolPlacemark.placemark
            cell?.detailTextLabel?.text = String(format: "%@, %@, %@", (placemark?.thoroughfare)!,(placemark?.locality)!, (placemark?.administrativeArea)!)
            return cell!
        case 2:
            //ShopAndEat
            let shopAndEatPlacemark = shopAndEatPlacemarks[indexPath.row]
            cell?.textLabel?.text = shopAndEatPlacemark.name
            let placemark = shopAndEatPlacemark.placemark
            cell?.detailTextLabel?.text = String(format: "%@, %@, %@", (placemark?.thoroughfare)!,(placemark?.locality)!, (placemark?.administrativeArea)!)
            return cell!
        default:
            cell?.textLabel?.text = ""
            return cell!
        }
    }
    
    //TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentioView.selectedSegmentioIndex{
        case 1:
            //Schools
            //Show School detail webpage
            break
        case 2:
            //ShopAndEat
            //Show Yelp detail webpage
            break
        default:
            break
        }
    }
    
    //PullUpController Functions
    override var pullUpControllerPreferredSize: CGSize {
        return CGSize(width: w, height: h-navigationHeaderAndStatusbarHeight-44)
    }
    
    override var pullUpControllerPreviewOffset: CGFloat {
        return 184.0
    }
    
    override var pullUpControllerMiddleStickyPoints: [CGFloat] {
        return [184.0, 350.0]
    }
    
    override var pullUpControllerIsBouncingEnabled: Bool {
        return false
    }
    
    override var pullUpControllerPreferredLandscapeFrame: CGRect {
        return CGRect(x: 0, y: navigationHeaderAndStatusbarHeight+44+35, width: w, height: h-navigationHeaderAndStatusbarHeight-44-35)
    }
    
    override var dismissableHeight: CGFloat{
        return 125.0
    }
    
    override var isDismissable: Bool{
        return true
    }
}

