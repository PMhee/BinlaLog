//
//  HomeController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/5/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
extension HomeViewController{
    func addProcedure(){
        self.performSegue(withIdentifier: "addProcedure", sender: self)
    }
    func addPatient(){
        self.performSegue(withIdentifier: "addPatient", sender: self)
    }
}
