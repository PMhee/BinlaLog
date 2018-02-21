//
//  ProcedureController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/5/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
extension ProcedureViewController{
    struct ViewModel {
        var searchKey : String?
        var procedures : [String:Results<Procedure>]?
    }
    func doClose(){
        self.dismiss(animated: true, completion: nil)
    }
    func loadDataFromServer(){
        BackProcedure.getInstance().enumProcedure(courseid: self.courseid, finish: {
            self.doSearchProcedure(key: self.viewModel.searchKey ?? "")
        })
        self.doSearchProcedure(key: self.viewModel.searchKey ?? "")
    }
    func doSearchProcedure(key:String){
        let procedures = BackProcedure.getInstance().list(key: key)
        self.viewModel.procedures = BackProcedure.getInstance().groupProcedure(procedures: procedures)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add"{
                if let des = segue.destination as? ProcedureAddViewController{
                    des.rotationid = self.rotationid
                    des.procedureid = self.procedureid
                }
        }
    }
}
extension ProcedureViewController.ViewModel{
    init(searchKey:String = "") {
        self.searchKey = searchKey
    }
}
