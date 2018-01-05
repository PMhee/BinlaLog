//
//  ProcedureController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/5/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
extension ProcedureViewController{
    func doClose(){
        self.dismiss(animated: true, completion: nil)
    }
    func loadDataFromServer(){
        //list all procedure
        APIPatient.listProcedure(finish: {(success) in
        }, fail: {(error) in
            
        })
    }
}
