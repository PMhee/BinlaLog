//
//  NTextField.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/3/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import UIKit
class NTextField: UITextField {
    @IBInspectable var top : CGFloat = 0{
        didSet{
            self.applyMask()
        }
    }
    @IBInspectable var left : CGFloat = 8{
        didSet{
            self.applyMask()
        }
    }
    @IBInspectable var bottom : CGFloat = 0{
        didSet{
            self.applyMask()
        }
    }
    @IBInspectable var right : CGFloat = 8{
        didSet{
            self.applyMask()
        }
    }
    var padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    func applyMask(){
        self.padding = UIEdgeInsets(top: self.top, left: self.left, bottom: self.bottom, right: self.right)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    //Make rect textfield with border and color grey
    func makeRectTextfield(){
        self.layer.borderColor = UIColor(netHex:0xeeeeee).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 2
    }
    //Make only bottom line textfield with color grey
    func makeBottomTextfield(){
        let bottomLine = CALayer()
        self.tintColor = UIColor.black
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height-1, width: self.frame.width, height: 0.5)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        self.borderStyle = UITextBorderStyle.none
        self.layer.addSublayer(bottomLine)
        self.layer.masksToBounds = true
    }
}
