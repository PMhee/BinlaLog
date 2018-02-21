//
//  HistoryViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/4/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UISearchResultsUpdating,UISearchBarDelegate {
    @IBAction func btn_procedure_action(_ sender: UIButton) {
        self.changePage(to: 0)
    }
    @IBAction func btn_patient_action(_ sender: UIButton) {
        self.changePage(to: 1)
    }
    @IBOutlet weak var vw_line_show_procedure: UIView!
    @IBOutlet weak var vw_line_show_patient: UIView!
    @IBOutlet weak var container_procedure: UIView!
    @IBOutlet weak var container_patient: UIView!
    @IBAction func btn_add_action(_ sender: UIBarButtonItem) {
        self.showAlert(sender:sender)
    }
    @IBAction func btn_filter_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "filter", sender: self)
    }
    @IBAction func btn_summary_action(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "summary", sender: self)
    }
    
    
    @IBOutlet weak var lb_rotation: UILabel!
    @IBOutlet weak var lb_rotation_deadline: UILabel!
    var isTeacher = false
    var isAddProcedure : Bool = true
    var searchController = UISearchController(searchResultsController: nil)
    var viewModel = ViewModel(){
        didSet{
            if !self.isTeacher{
                if let user = self.viewModel.user{
                    if let rotation = BackRotation.getInstance().get(id: user.currentSelectRotation){
                        lb_rotation.watch(subject: rotation.rotationname)
                        if rotation.logbookendtime.offset(from: Date()) == "Just now"{
                            lb_rotation_deadline.text = "The rotation has been end"
                        }else{
                            lb_rotation_deadline.watch(subject: "Deadline in "+rotation.logbookendtime.offset(from: Date()))
                        }
                    }
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCurrentRotation()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRecentRotation()
        self.setUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchController.isActive = false
        searchController.dismiss(animated: false, completion: nil)
    }
    func setUI(){
        self.container_procedure.isHidden = false
        self.container_patient.isHidden = true
        self.vw_line_show_procedure.backgroundColor = Constant().getColorMain()
        self.vw_line_show_patient.backgroundColor = UIColor.white
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
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        NotificationCenter.default.post(name: .textChange, object: nil, userInfo: ["text":text])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

