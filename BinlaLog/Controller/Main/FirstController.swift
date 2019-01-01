//
//  FirstController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/3/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
extension FirstViewController{
    //check session is existing everytime you run the app
    func doCheckSession(){
//        if BackUser.getInstance().get() != nil{
//            BackRotation.getInstance().SelectCurrentRotation(finish: {
//                if let user = BackUser.getInstance().get(){
//                    if user.role == "teacher".uppercased(){
//                        self.performSegue(withIdentifier: "doAppTeacher", sender: self)
//                    }else{
//                         self.performSegue(withIdentifier: "doAppStudent", sender: self)
//                    }
//                }
//            }, error: {
//                self.doLogout()
//            })
//
//        }else{
//            self.performSegue(withIdentifier: "doLogin", sender: self)
//        }
        if let user = BackUser.getInstance().get(){
            if user.role == "teacher".uppercased(){
                self.performSegue(withIdentifier: "doAppTeacher", sender: self)
            }else{
                self.performSegue(withIdentifier: "doAppStudent", sender: self)
            }
        }else{
            self.performSegue(withIdentifier: "doLogin", sender: self)
        }
    }
}
