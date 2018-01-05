//
//  LoginController.swift
//  BinlaLog
//
//  Created by Tanakorn on 12/25/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import UIKit
extension LoginViewController{
    //login to application
    func doSignin(){
        Helper.showLoading(sender: self)
        self.view.endEditing(true)
        guard let username = self.viewLogin.tf_username.text else{
            return
        }
        guard let password = self.viewLogin.tf_password.text else{
            return
        }
        APIUser.login(username: username, password: password, finish: {(success) in
            self.dismiss(animated: false, completion: nil)
            self.performSegue(withIdentifier: "doApp", sender: self)
        }, fail: {(error) in
            self.dismiss(animated: false, completion: nil)
            Helper.addAlert(sender: self,title:"Error",message:"Username or password is not correct")
        })
     }
    
}
