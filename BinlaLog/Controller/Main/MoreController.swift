//
//  MoreController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/3/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
extension MoreViewController{
    //logout form application
    func doLogout(){
        Helper.showLoading(sender: self)
        Helper.delay(2, closure: {
            self.dismiss(animated: false, completion: nil)
            BackUser.getInstance().removeAll()
            self.performSegue(withIdentifier: "logout", sender: self)
        })
    }
}
