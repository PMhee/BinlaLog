//
//  LoginViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 12/25/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var viewLogin: LoginPresentation!
    @IBAction func btn_signin_action(_ sender: UIButton) {
        self.doSignin()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewLogin.viewModel = LoginPresentation.ViewModel(name: Constant().getAppName(), colorMain: Constant().getColorMain(),logo:Constant().getLogo())
        self.viewLogin.setUI()
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 1{
            self.doSignin()
        }
        return true
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
