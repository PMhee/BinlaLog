//
//  HistoryContriller.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/4/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import UIKit
extension HistoryViewController{
    struct ViewModel {
        var user : User?
    }
    //switch page between procedure and patient.
    func changePage(to:Int){
        self.changeToBeDefault()
        if to == 0 {
            self.vw_line_show_procedure.backgroundColor = Constant().getColorMain()
            self.container_procedure.isHidden = false
        }else{
            self.vw_line_show_patient.backgroundColor = Constant().getColorMain()
            self.container_patient.isHidden = false
        }
    }
    //change
    func changeToBeDefault(){
        self.vw_line_show_patient.backgroundColor = UIColor.white
        self.vw_line_show_procedure.backgroundColor = UIColor.white
        self.container_patient.isHidden = true
        self.container_procedure.isHidden = true
    }
    func doSearchProcedure(key:String){
        
    }
    func doSearchPatient(key:String){
        
    }
    func showAlert(sender:UIBarButtonItem){
        let actionSheet = UIAlertController(title: "Rotation", message: BackRotation.getInstance().get(id: BackUser.getInstance().get()?.currentSelectRotation ?? "")?.rotationname ?? "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            print("Cancel")
        }))
        actionSheet.addAction(UIAlertAction(title: "\(Constant().getFirstPageTitle())", style: .default, handler: {
            action in
            self.isAddProcedure = true
            if let user = self.viewModel.user{
                if let rotation = BackRotation.getInstance().get(id: user.currentSelectRotation){
                    if rotation.logbookendtime.offset(from: Date()) == "Just now"{
                        Helper.showWarning(sender: self, text: "The rotation has been end")
                    }else{
                        self.performSegue(withIdentifier: "addProcedure", sender: self)
                    }
                }
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Patient", style: .default, handler: {
            action in
            self.isAddProcedure = false
            if let user = self.viewModel.user{
                if let rotation = BackRotation.getInstance().get(id: user.currentSelectRotation){
                    if rotation.logbookendtime.offset(from: Date()) == "Just now"{
                        Helper.showWarning(sender: self, text: "The rotation has been end")
                    }else{
                        self.performSegue(withIdentifier: "addPatient", sender: self)
                    }
                }
            }
        }))
        actionSheet.popoverPresentationController?.sourceView = self.view
        let view = sender.value(forKey: "view") as! UIView
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.width, y: 0, width: view.frame.width, height: view.frame.height)
        self.present(actionSheet, animated: true, completion: nil)
    }
    func getCurrentRotation(){
        BackRotation.getInstance().getCurrentRotation {
            self.viewModel.user = BackUser.getInstance().get()
        }
        self.viewModel.user = BackUser.getInstance().get()
    }
    func getRecentRotation(){
        BackRotation.getInstance().getRecentRotation {
            self.viewModel.user = BackUser.getInstance().get()
        }
        self.viewModel.user = BackUser.getInstance().get()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addProcedure"{
            if let navigation = segue.destination as? UINavigationController{
                if let des = navigation.topViewController as? ProcedureViewController{
                    des.rotationid = BackRotation.getInstance().get(id: BackUser.getInstance().get()?.currentSelectRotation ?? "")?.id ?? ""
                    des.courseid = BackRotation.getInstance().get(id: BackUser.getInstance().get()?.currentSelectRotation ?? "")?.courseid ?? ""
                }
            }
        }else if segue.identifier == "addPatient"{
            if let navigation = segue.destination as? UINavigationController{
                if let des = navigation.topViewController as? PatientViewController{
                    des.rotationid = BackRotation.getInstance().get(id: BackUser.getInstance().get()?.currentSelectRotation ?? "")?.id ?? ""
                }
            }
        }else if segue.identifier == "summary"{
            if let des = segue.destination as? SummaryViewController{
                if let user = self.viewModel.user{
                    if let rotation = BackRotation.getInstance().get(id: user.currentSelectRotation){
                        des.rotationid = rotation.id
                    }
                }
            }
        }
    }
}
