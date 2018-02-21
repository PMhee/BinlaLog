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
    var keyboard : CGFloat = 0
    @IBInspectable var keyboardUp : CGFloat = 20{
        didSet{
            self.keyboard = keyboardUp
        }
    }
    override func awakeFromNib() {
        self.addDismissTap()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShowNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let frameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let frame = frameValue.cgRectValue
                self.contentInset.bottom = frame.size.height + self.keyboard
            }
        }
        
    }
    @objc func keyboardWillHideNotification(notification: NSNotification) {
        self.contentInset.bottom = 0
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func addDismissTap(){
        let tapper = UITapGestureRecognizer(target: self, action:#selector(UIView.endEditing(_:)))
        tapper.cancelsTouchesInView = false
        self.addGestureRecognizer(tapper)
    }
}
