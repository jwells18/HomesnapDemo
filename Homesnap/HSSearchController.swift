//
//  PISearchController.swift
//  WalkieTalkie
//
//  Created by Justin Wells on 3/25/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import UIKit

protocol HSSearchControllerDelegate {
    func didStartSearching()
    func didEndSearching()
    func didTapOnSearchButton()
    func didTapOnCancelButton()
    func didTapOnBookmarkButton()
    func didChangeSearchText(searchText: String)
}

class HSSearchController: UISearchController, UISearchBarDelegate{
    
    var customSearchBar: HSSearchBar!
    var customDelegate: HSSearchControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Setup Search Controller
    init(searchResultsController: UIViewController!, searchBarFrame: CGRect, searchBarFont: UIFont, searchBarTextColor: UIColor, searchBarTintColor: UIColor, searchBarBackgroundColor: UIColor) {
        super.init(searchResultsController: searchResultsController)
        
        self.dimsBackgroundDuringPresentation = false
        configureSearchBar(frame: searchBarFrame, font: searchBarFont, textColor: searchBarTextColor, tintColor:searchBarTintColor, bgColor: searchBarBackgroundColor)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //Setup SearchBar
    func configureSearchBar(frame: CGRect, font: UIFont, textColor: UIColor, tintColor: UIColor, bgColor: UIColor) {
        customSearchBar = HSSearchBar(frame: frame, font: font, textColor: textColor, tintColor: tintColor, bgColor: bgColor)
        customSearchBar.placeholder = NSLocalizedString("Search", comment: " ")
        customSearchBar.showsBookmarkButton = false
        customSearchBar.showsCancelButton = false
        customSearchBar.translatesAutoresizingMaskIntoConstraints = false
        customSearchBar.delegate = self
    }
    
    //SearchBar Delegates
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        customDelegate.didStartSearching()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        customDelegate.didEndSearching()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        customDelegate.didTapOnBookmarkButton()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        customSearchBar.resignFirstResponder()
        customDelegate.didTapOnSearchButton()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        customSearchBar.resignFirstResponder()
        customDelegate.didTapOnCancelButton()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        customDelegate.didChangeSearchText(searchText: searchText)
    }

}
