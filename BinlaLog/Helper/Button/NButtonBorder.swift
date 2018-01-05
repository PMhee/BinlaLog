//
//  NButtonBorder.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/4/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import UIKit
class NButtonBorder:UIButton{
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    //Normal state bg and border
    @IBInspectable var normalBorderColor: UIColor? {
        didSet {
            layer.borderColor = normalBorderColor?.cgColor
        }
    }
    
    
    //Highlighted state bg and border

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 2
        clipsToBounds = true
        
        if borderWidth > 0 {
            if state == .normal{
                layer.borderColor = normalBorderColor?.cgColor
            }
        }
    }
}
