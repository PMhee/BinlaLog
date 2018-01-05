//
//  ProcedureViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/5/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class ProcedureViewController: UIViewController {

    @IBAction func btn_close_action(_ sender: UIBarButtonItem) {
        self.doClose()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDataFromServer()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    func setUI(){
        UIApplication.shared.statusBarStyle = .default
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            let searchController = UISearchController(searchResultsController: nil)
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
