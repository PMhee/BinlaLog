//
//  HomeController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/5/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import UIKit
extension HomeViewController{
    struct ViewModel {
        var user : User?
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
    func addProcedure(tag:Int){
        self.index = tag
        self.performSegue(withIdentifier: "addProcedure", sender: self)
    }
    func addPatient(tag:Int){
        self.index = tag
        self.performSegue(withIdentifier: "addPatient", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addProcedure"{
            if let navigation = segue.destination as? UINavigationController{
                if let des = navigation.topViewController as? ProcedureViewController{
                    des.rotationid = self.viewModel.user!.currentRotation[self.index].rotationid
                }
            }
        }else if segue.identifier == "addPatient"{
            if let navigation = segue.destination as? UINavigationController{
                if let des = navigation.topViewController as? PatientViewController{
                    des.rotationid = self.viewModel.user!.currentRotation[self.index].rotationid
                }
            }
        }else if segue.identifier == "summary"{
            if let des = segue.destination as? SummaryViewController{
                des.rotationid = self.rotationid
            }
        }
    }
}
extension HomeViewController.ViewModel{
    init(user:User = User()) {
        self.user = user
    }
}
