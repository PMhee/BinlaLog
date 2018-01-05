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
        if BackUser.getInstance().get() != nil{
            self.performSegue(withIdentifier: "doApp", sender: self)
        }else{
            self.performSegue(withIdentifier: "doLogin", sender: self)
        }
    }
}
