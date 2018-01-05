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
    //switch page between procedure and patient.
    func changePage(to:Int){
        self.changeToBeDefault()
        if to == 0 {
            self.vw_line_show_procedure.backgroundColor = UIColor(netHex:Constant().getColorMain())
            self.container_procedure.isHidden = false
        }else{
            self.vw_line_show_patient.backgroundColor = UIColor(netHex:Constant().getColorMain())
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
}
