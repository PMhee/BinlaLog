//
//  Helper.swift
//  BinlaLog
//
//  Created by Tanakorn on 12/25/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import UIKit
public extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
extension UIView{
    func shadow(){
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.24
        self.layer.shadowRadius = CGFloat(2)
    }
}
class Helper{
    static func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    static func showLoading(sender:UIViewController){
        let storyboard = UIStoryboard(name: "Helper", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController
        sender.modalPresentationStyle = .overCurrentContext
        sender.present(vc, animated: false, completion: nil)
    }
    static func addAlert(sender:UIViewController,title:String="",message:String=""){
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {action in
        }))
        sender.present(alert, animated: true, completion: nil)
    }
    
}
