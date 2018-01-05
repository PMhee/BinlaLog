//
//  ViewLogin.swift
//  BinlaLog
//
//  Created by Tanakorn on 12/25/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class LoginPresentation: ScrollView {
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var tf_username: NTextField!
    @IBOutlet weak var tf_password: NTextField!
    @IBOutlet weak var btn_signin: UIButton!
    var viewModel : ViewModel = ViewModel(){
        didSet{
            self.btn_signin.backgroundColor = UIColor(netHex:viewModel.colorMain)
            self.img_logo.image = UIImage(named:viewModel.logo)
        }
    }
    func setUI(){
        self.img_logo.layer.cornerRadius = 50
        self.img_logo.layer.masksToBounds = true
        self.btn_signin.layer.cornerRadius = 3
        self.btn_signin.shadow()
        self.tf_username.makeBottomTextfield()
        self.tf_password.makeBottomTextfield()
    }
    
}
extension LoginPresentation {
    struct ViewModel {
        let appname : String
        let colorMain : Int
        let logo : String
    }
}

extension LoginPresentation.ViewModel {
    init(name:String="",colorMain:Int=0,logo:String=""){
        self.appname = name
        self.colorMain = colorMain
        self.logo = logo
    }
}
