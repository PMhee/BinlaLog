//
//  NotificationViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 9/2/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class NotificationViewController: UIViewController,UISearchResultsUpdating,UISearchBarDelegate {
    var searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableView: UITableView!
    var viewModel = ViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchController.isActive = false
        searchController.dismiss(animated: false, completion: nil)
    }
    func setUI(){
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = false
            searchController.searchBar.barTintColor = UIColor.white
            searchController.searchBar.backgroundColor = UIColor.clear
            searchController.searchBar.tintColor = UIColor.white
            searchController.searchBar.delegate = self
            self.definesPresentationContext = true
            if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                if let backgroundview = textfield.subviews.first {
                    backgroundview.backgroundColor = UIColor.white
                    backgroundview.layer.cornerRadius = 10;
                    backgroundview.clipsToBounds = true;
                }
            }
            //self.definesPresentationContext = false
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
extension NotificationViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.logbookPatient.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notfound", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "procedure", for: indexPath)
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.logbookPatient.count == 0 {
            return 1
        }else{
            return self.viewModel.logbookPatient.count
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.viewModel.logbookPatient.count > 0{
            
        }
    }
}
extension NotificationViewController{
    struct ViewModel {
        var logbookPatient = [LogbookPatient]()
    }
    struct LogbookPatient {
        var logbook : Logbook?
        var patient : PatientCare?
    }
    
}
