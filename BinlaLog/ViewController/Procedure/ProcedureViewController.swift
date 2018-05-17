//
//  ProcedureViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/5/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class ProcedureViewController: UIViewController,UISearchResultsUpdating,UITableViewDelegate {
    var index = 0
    //Routing
    var rotationid : String = ""
    var procedureid : String = ""
    var courseid : String = ""
    @IBOutlet var tableView: UITableView!
    var searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var act_loading: UIActivityIndicatorView!
    var viewLoading = UIViewController()
    var viewModel = ViewModel(){
        didSet{
            self.tableView.reloadData()
        }
    }
    func initViewModel() {
        self.viewModel = ViewModel(searchKey: "")
        self.doSearchProcedure(key: self.viewModel.searchKey ?? "")
    }
    @IBAction func btn_close_action(_ sender: UIBarButtonItem) {
        self.doClose()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.loadDataFromServer()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.searchController.isActive == true {
            self.searchController.isActive = false
        }
    }
    func setUI(){
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = false
            searchController.searchBar.barTintColor = UIColor.white
            searchController.searchBar.backgroundColor = UIColor.clear
            searchController.searchBar.tintColor = UIColor.white
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
        guard let text = searchController.searchBar.text else {
            return
        }
        self.doSearchProcedure(key: text)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.index = indexPath.row
        if self.viewModel.procedures != nil{
            if self.viewModel.procedures.count > 0 {
                self.performSegue(withIdentifier: "add", sender: self)
            }
        }
    }
}
extension ProcedureViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.procedures.count != 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProcedureTableViewCell
            if let gr = BackProcedure.getInstance().getGroup(id: Array(self.viewModel.procedures.keys)[indexPath.row]){
                cell.lb_procedure_group.text = gr.procgroupname
            }
            cell.procedures = Array(self.viewModel.procedures)[indexPath.row].value
            cell.setDelegate()
            cell.sender = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "notfound", for: indexPath)
            return cell
        }
    }
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.viewModel.procedures.count == 0{
        return 1
    }else{
        return self.viewModel.procedures.count
    }
}
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
}
func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
}
}
