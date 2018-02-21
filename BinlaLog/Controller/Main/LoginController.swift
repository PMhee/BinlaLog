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
        APIUser.login(username: self.viewModel.username, password: self.viewModel.password, finish: {(success) in
            self.dismiss(animated: false, completion: nil)
            BackRotation.getInstance().getCurrentRotation {
                if BackUser.getInstance().get()?.role == "teacher".uppercased(){
                    self.performSegue(withIdentifier: "doAppTeacher", sender: self)
                }else{
                    self.performSegue(withIdentifier: "doAppStudent", sender: self)
                }
            }
        }, fail: {(error) in
            self.dismiss(animated: false, completion: nil)
            Helper.addAlert(sender: self,title:"Error",message:"Username or password is not correct")
        })
     }
    
}
