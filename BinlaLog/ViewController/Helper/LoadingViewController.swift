//
//  LoadingViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 12/25/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {


    @IBOutlet weak var act: UIActivityIndicatorView!
    @IBOutlet weak var vw_loading: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.act.startAnimating()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
