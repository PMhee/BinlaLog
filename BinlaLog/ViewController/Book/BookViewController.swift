//
//  BookViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 21/2/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    //Routing
    var eBookTitle : String = ""
    @IBOutlet weak var lb_title: UILabel!
    @IBAction func btn_cancel_action(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lb_title.text = eBookTitle
        self.setUI()
        // Do any additional setup after loading the view.
    }
    func setUI(){
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
