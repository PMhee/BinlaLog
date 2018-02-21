//
//  Observer.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/10/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit
import Foundation
extension UITextField{
    func watch(subject:String){
        self.text = subject
    }
}
extension UILabel{
    func watch(subject:String){
        self.text = subject
    }
}
extension UISegmentedControl{
    func watch(subject:Int){
        self.selectedSegmentIndex = subject
    }
}
