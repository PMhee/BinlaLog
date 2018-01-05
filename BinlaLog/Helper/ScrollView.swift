//
//  ScrollView.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/3/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import UIKit
class ScrollView:UIScrollView{
    override func awakeFromNib() {
        self.addDismissTap()
    }
    func addDismissTap(){
        let tapper = UITapGestureRecognizer(target: self, action:#selector(UIView.endEditing(_:)))
        tapper.cancelsTouchesInView = false
        self.addGestureRecognizer(tapper)
    }
}
