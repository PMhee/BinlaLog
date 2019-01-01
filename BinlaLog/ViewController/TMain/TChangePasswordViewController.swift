//
//  TChangePasswordViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 5/4/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class TChangePasswordViewController: UIViewController {

    @IBOutlet weak var tf_old_password: UITextField!
    @IBOutlet weak var tf_new_password: UITextField!
    @IBOutlet weak var tf_confirm_password: UITextField!
    @IBAction func btn_done_action(_ sender: UIBarButtonItem) {
        if self.tf_new_password.text! == self.tf_confirm_password.text!{
            if self.tf_new_password.text!.characters.count > 5{
                BackUser.getInstance().changePassword(old: self.tf_old_password.text!, new: self.tf_new_password.text!, success: {
                    self.navigationController?.popViewController(animated: true)
                }, error: {
                    let alert = UIAlertController(title: "Wrong password", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in }))
                    self.present(alert, animated: true, completion: nil)
                })
            }else{
                let alert = UIAlertController(title: "New Password must has atleast 6 characters", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in }))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "Password mismatch", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
