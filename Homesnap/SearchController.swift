//
//  SearchController.swift
//  Homesnap
//
//  Created by Justin Wells on 3/23/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit
import MapKit

class SearchController: UIViewController, HSSearchControllerDelegate, MKMapViewDelegate, SearchListViewDelegate, PullupControllerDelegate{
    
    private var annotationIndentifier = "annotationIdentifier"
    private var isShowingMap = true
    private var searchMapView: SearchMapView!
    private var searchListView: SearchListView!
    private var listings = [Listing]()
    private var localInfoVC = LocalInfoController()
    private var isShowingLocalInfoVC = false
    private var listingDetailVC = ListingDetailController()
    private var isShowingListingDetailVC = false
    private var selectedAnnotation: HSMapAnnotation!
    private var searchController: HSSearchController!
    private var mapManager = HSMapManager()
    private var cameraButton: UIBarButtonItem!
    private var filterButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup NavigationBar
        self.setupNavigationBar()
        
        //Setup View
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Show Navigation Bar
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        searchListView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setupNavigationBar(){
        //Setup SearchController
        searchController = HSSearchController(searchResultsController: self, searchBarFrame: CGRect(x:0, y:0, width:w, height:50), searchBarFont: UIFont.boldSystemFont(ofSize: searchBarFontSize), searchBarTextColor: UIColor.darkGray, searchBarTintColor: UIColor.lightGray, searchBarBackgroundColor: HSColor.faintGray)
        searchController.customDelegate = self
        self.navigationItem.titleView = searchController.customSearchBar
        
        //Set Navigation Items
        cameraButton = UIBarButtonItem(image: UIImage(named: "camera"), style: .plain, target: self, action: #selector(cameraButtonPressed))
        self.navigationItem.leftBarButtonItem = cameraButton
        filterButton = UIBarButtonItem(title: "filter".localized(), style: .plain, target: self, action: #selector(filterButtonPressed))
        self.navigationItem.rightBarButtonItem = filterButton
        
        //Remove Gray Hairline
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupView(){
        //Set Background Color
        self.view.backgroundColor = HSColor.faintGray
        
        //Setup SearchListView
        self.setupSearchListView()
        
        //Setup SearchMapView
        self.setupSearchMapView()
        
        //Add Local Info ViewController to SearchMapView
        self.setupLocalInfoVC()
        
        //Add ListingDetail ViewController to SearchMapView
        self.setupListingDetailVC()
        
        //Setup Constraints
        self.setupConstraints()
    }
    
    func setupSearchListView(){
        searchListView = SearchListView(frame: CGRect.zero)
        searchListView.translatesAutoresizingMaskIntoConstraints = false
        searchListView.searchListViewDelegate = self
        searchListView.segmentioView.indexPressed = { segmentio, segmentIndex in
            switch segmentIndex {
            case 0:
                //Sort
                //Show Feature Unavailable
                self.present(featureUnavailableAlert(), animated: true, completion: nil)
                break
            case 1:
                //Save Search
                //Show Feature Unavailable
                self.present(featureUnavailableAlert(), animated: true, completion: nil)
                break
            case 2:
                //Show Map View
                self.isShowingMap = true
                self.flipView(firstView: self.searchListView, secondView: self.searchMapView)
                if self.isShowingLocalInfoVC || self.isShowingListingDetailVC{
                    self.tabBarController?.tabBar.isHidden = true
                }
                else{
                    self.tabBarController?.tabBar.isHidden = false
                }
                break
            default:
                break
            }
        }
        searchListView.isHidden = true
        self.view.addSubview(searchListView)
    }
    
    func setupSearchMapView(){
        searchMapView = SearchMapView(frame: CGRect.zero)
        searchMapView.translatesAutoresizingMaskIntoConstraints = false
        searchMapView.mapView.delegate = self
        searchMapView.segmentioView.indexPressed = { segmentio, segmentIndex in
            switch segmentIndex {
            case 0:
                //Local Info
                if self.isShowingLocalInfoVC{
                    self.hideLocalInfoController()
                }
                else{
                    if self.isShowingListingDetailVC{
                        self.hideListingDetailController()
                    }
                    self.showLocalInfoController()
                }
                break
            case 1:
                //Save Search
                //Show Feature Unavailable
                self.present(featureUnavailableAlert(), animated: true, completion: nil)
                break
            case 2:
                //Show List View
                self.isShowingMap = false
                self.flipView(firstView: self.searchMapView, secondView: self.searchListView)
                self.tabBarController?.tabBar.isHidden = false
                //Refresh TableView
                self.searchListView.configure(listings: self.listings)
                break
            default:
                break
            }
        }
        searchMapView.mapViewTypeButton.addTarget(self, action: #selector(mapViewTypeButtonPressed), for: .touchUpInside)
        searchMapView.mapViewNearbyButton.addTarget(self, action: #selector(mapViewNearbyButtonPressed), for: .touchUpInside)
        searchMapView.isHidden = false
        self.view.addSubview(searchMapView)
    }
    
    func setupLocalInfoVC(){
        localInfoVC.cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        localInfoVC.pullupControllerDelegate = self
        localInfoVC.segmentioView.valueDidChange = { segmentio, segmentIndex in
            //Remove all LocalInfo Annotations
            self.removeLocalInfoAnnotations()
            self.localInfoVC.resetData()
            switch segmentIndex{
            case 0:
                //Crimes - do not have API key to search
                self.localInfoVC.pullUpControllerMoveToVisiblePoint(350.0, completion:nil)
                //let spotCrime = SpotCrime()
                //spotCrime.getCrimes(location: self.searchMapView.mapView.centerCoordinate, radius: 0.01)
                self.localInfoVC.tableView.reloadData()
                break
            case 1:
                //Schools
                self.localInfoVC.pullUpControllerMoveToVisiblePoint(350.0, completion:nil)
                self.mapManager.mapLocalSearch(string: "schools", region: self.searchMapView.mapView.region, completionHandler: { (annotations: [HSMapAnnotation]) in
                    self.searchMapView.mapView.addAnnotations(annotations)
                    //Configure Table with local search data
                    self.localInfoVC.configure(schoolAnnotations: annotations)
                })
                break
            case 2:
                //Shop & Eat
                self.localInfoVC.pullUpControllerMoveToVisiblePoint(350.0, completion:nil)
                self.mapManager.mapLocalSearch(string: "restaurants", region: self.searchMapView.mapView.region, completionHandler: { (annotations: [HSMapAnnotation]) in
                    self.searchMapView.mapView.addAnnotations(annotations)
                    //Configure Table with local search data
                    self.localInfoVC.configure(shopAndEatAnnotations: annotations)
                    })
                break
            default:
                self.localInfoVC.pullUpControllerMoveToVisiblePoint(175.0, completion:nil)
                self.localInfoVC.tableView.reloadData()
                break
            }
        }
    }
    
    func setupListingDetailVC(){
        //Show Delete Popup
        listingDetailVC.pullupControllerDelegate = self
    }
    
    func setupConstraints(){
        let viewDict = ["searchMapView": searchMapView, "searchListView": searchListView] as [String : Any]
        //Width & Horizontal Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[searchMapView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[searchListView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        //Height & Vertical Alignment
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[searchMapView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[searchListView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
    
    //BarButtonItem Delegate
    func cameraButtonPressed(){
        let cameraVC = CameraController()
        cameraVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(cameraVC, animated: true)
    }
    
    func filterButtonPressed(){
        let filterVC = FilterListingsController()
        let navVC = NavigationController(rootViewController: filterVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
    //Button Delegates
    func mapViewTypeButtonPressed(){
        switch searchMapView.mapView.mapType{
        case .standard:
            searchMapView.mapViewTypeButton.setTitle("flyover".localized(), for: .normal)
            searchMapView.mapViewTypeButton.setImage(UIImage(named:"mapFlyover"), for: .normal)
            searchMapView.mapView.mapType = .satelliteFlyover
            break
        case .satelliteFlyover:
            searchMapView.mapViewTypeButton.setTitle("satellite".localized(), for: .normal)
            searchMapView.mapViewTypeButton.setImage(UIImage(named:"mapSatellite"), for: .normal)
            searchMapView.mapView.mapType = .satellite
            break
        case .satellite:
            searchMapView.mapViewTypeButton.setTitle("hybrid".localized(), for: .normal)
            searchMapView.mapViewTypeButton.setImage(UIImage(named:"mapHybrid"), for: .normal)
            searchMapView.mapView.mapType = .hybrid
            break
        case .hybrid:
            searchMapView.mapViewTypeButton.setTitle("map".localized(), for: .normal)
            searchMapView.mapViewTypeButton.setImage(UIImage(named:"mapDefault"), for: .normal)
            searchMapView.mapView.mapType = .standard
            break
        default:
            searchMapView.mapViewTypeButton.setTitle("map".localized(), for: .normal)
            searchMapView.mapViewTypeButton.setImage(UIImage(named:"mapDefault"), for: .normal)
            searchMapView.mapView.mapType = .standard
            break
        }
    }
    
    func mapViewNearbyButtonPressed(){
        //Show Feature Unavailable
        self.present(featureUnavailableAlert(), animated: true, completion: nil)
    }
    
    func cancelButtonPressed(){
        self.hideLocalInfoController()
        self.removeLocalInfoAnnotations()
    }

    //Transition Animation
    func flipView(firstView: UIView, secondView: UIView) {
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(with: firstView, duration: 1.0, options: transitionOptions, animations: {
            firstView.isHidden = true
        })
        
        UIView.transition(with: secondView, duration: 1.0, options: transitionOptions, animations: {
            secondView.isHidden = false
        })
    }
    
    //SearchListView Delegate
    func didPressCell(indexPath: IndexPath?){
        //Handle Cell Pressed
        //Show Feature Unavailable
        self.present(featureUnavailableAlert(), animated: true, completion: nil)
    }
    
    func didPressSave(indexPath: IndexPath?){
        //Save Listing
        //Show Feature Unavailable
        self.present(featureUnavailableAlert(), animated: true, completion: nil)
    }
    
    func didPressMore(sender:UIButton){
        //Show More
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alertAction) in
            //Save
            //Show Feature Unavailable
            self.present(featureUnavailableAlert(), animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Message", style: .default, handler: { (alertAction) in
            //Message
            //Show Feature Unavailable
            self.present(featureUnavailableAlert(), animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { (alertAction) in
            //Share
            //Show Feature Unavailable
            self.present(featureUnavailableAlert(), animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.popoverPresentationController?.sourceView = sender
        alert.popoverPresentationController?.sourceRect = CGRect(x: sender.frame.width/2, y: sender.frame.height, width: CGFloat(1), height: CGFloat(1))
        alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        self.present(alert, animated: true, completion: nil)
    }
    
    //SearchMapView Delegate
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //Remove all annotations
        searchMapView.mapView.removeAnnotations(searchMapView.mapView.annotations)
        
        //Search for listings
        mapManager.queryListings(region: searchMapView.mapView.region, completionHandler: { (annotations: [HSMapAnnotation], listings: [Listing]) in
            self.searchMapView.mapView.addAnnotations(annotations)
            self.listings = listings
        })
        
        //Search for Local Data (if necessary)
        if isShowingLocalInfoVC{
            self.localInfoVC.resetData()
            switch localInfoVC.segmentioView.selectedSegmentioIndex{
            case 0:
                //Crimes - do not have API key to search
                //let spotCrime = SpotCrime()
                //spotCrime.getCrimes(location: self.searchMapView.mapView.centerCoordinate, radius: 0.01)
                //self.localInfoVC.configure(crimes: [Crime])
                self.localInfoVC.tableView.reloadData()
                break
            case 1:
                //Schools
                self.mapManager.mapLocalSearch(string: "schools", region: self.searchMapView.mapView.region, completionHandler: { (annotations: [HSMapAnnotation]) in
                    self.searchMapView.mapView.addAnnotations(annotations)
                    self.localInfoVC.configure(schoolAnnotations: annotations)
                })
                //Configure Table with local search data
                break
            case 2:
                //Shop & Eat
                self.mapManager.mapLocalSearch(string: "restaurants", region: self.searchMapView.mapView.region, completionHandler: { (annotations: [HSMapAnnotation]) in
                    self.searchMapView.mapView.addAnnotations(annotations)
                    self.localInfoVC.configure(shopAndEatAnnotations: annotations)
                })
                //Configure Table with local search data
                break
            default:
                self.localInfoVC.tableView.reloadData()
                break
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIndentifier)
        //Note: Registering annotationViews is the best protocol, but only available in iOS 11+
        
        if (annotationView == nil){
            if annotation.isKind(of: HSMapAnnotation.self){
                let customAnnotation = HSAnnotationView(annotation: annotation, reuseIdentifier: annotationIndentifier)
                annotationView = customAnnotation
            }
        }
        else{
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //Show Listing Popup Controller
        let annotation = view.annotation as! HSMapAnnotation
        selectedAnnotation = annotation
        switch annotation.type!{
        case .school:
            break
        case .shopAndEat:
            break
        case .listing:
            if isShowingLocalInfoVC{
                self.hideLocalInfoController()
            }
            
            let placemark = annotation.placemark as! ListingPlacemark
            let listing = placemark.listing
            self.showListingDetailController(listing: listing!)
            break
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        //Show Listing Popup Controller
        let annotation = view.annotation as! HSMapAnnotation
        selectedAnnotation = nil
        switch annotation.type!{
        case .school:
            break
        case .shopAndEat:
            break
        case .listing:
            self.hideListingDetailController()
            break
        }
    }
    
    func removeLocalInfoAnnotations(){
        for annotation in searchMapView.mapView.annotations{
            let mapAnnotation = annotation as! HSMapAnnotation
            if(mapAnnotation.type != .listing){
                searchMapView.mapView.removeAnnotation(annotation)
            }
        }
    }
    
    //PullupController Delegates
    func pullupControllerDidDismiss(){
        isShowingLocalInfoVC = false
        isShowingListingDetailVC = false
        
        //Remove all LocalInfo Annotations
        self.removeLocalInfoAnnotations()
        self.localInfoVC.resetData()
    
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func pullupControllerDidPan(currentHeight: CGFloat){
        if isShowingLocalInfoVC{
            if currentHeight >= 115{
                localInfoVC.tableView.frame = CGRect(x:0, y: 115, width: w, height: currentHeight-115)
            }
            else{
                localInfoVC.tableView.frame = CGRect.zero
            }
        }
    }
    
    func showLocalInfoController(){
        if !isShowingLocalInfoVC{
            self.addPullUpController(pullUpController: localInfoVC, attachView: searchMapView)
        }
        isShowingLocalInfoVC = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func hideLocalInfoController(){
        localInfoVC.dismiss()
        isShowingLocalInfoVC = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func showListingDetailController(listing: Listing){
        listingDetailVC.configure(listing: listing)
        if !isShowingListingDetailVC{
            self.addPullUpController(pullUpController: listingDetailVC, attachView: searchMapView)
        }
        isShowingListingDetailVC = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func hideListingDetailController(){
        listingDetailVC.dismiss()
        isShowingListingDetailVC = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //SearchController Delegate
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func didStartSearching() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        searchController.customSearchBar.showsCancelButton = true
    }
    
    func didEndSearching() {
        self.navigationItem.leftBarButtonItem = cameraButton
        self.navigationItem.rightBarButtonItem = filterButton
        searchController.customSearchBar.showsCancelButton = false
    }
    
    func didTapOnBookmarkButton(){
        
    }
    
    func didTapOnSearchButton() {
        
    }
    
    func didTapOnCancelButton() {
        
    }
    
    func didChangeSearchText(searchText: String) {
        
    }
}

extension MKMapView {
    
    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        return MKMapRectContainsPoint(self.visibleMapRect, MKMapPointForCoordinate(coordinate))
    }
}




