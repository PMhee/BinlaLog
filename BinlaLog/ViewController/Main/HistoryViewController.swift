//
//  HistoryViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/4/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    func setUI(){
        self.container_procedure.isHidden = false
        self.container_patient.isHidden = true
        self.vw_line_show_procedure.backgroundColor = UIColor(netHex:Constant().getColorMain())
        self.vw_line_show_patient.backgroundColor = UIColor.white
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
