//
//  PatientViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/5/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class PatientViewController: UIViewController {

    @IBOutlet weak var tf_hn: NTextField!
    @IBOutlet weak var tf_name: NTextField!
    
    @IBAction func btn_cancel_action(_ sender: UIBarButtonItem) {
        self.doClose()
    }
    @IBAction func btn_save_action(_ sender: UIBarButtonItem) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    func setUI(){
        self.tf_hn.makeBottomTextfield()
        self.tf_name.makeBottomTextfield()
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
