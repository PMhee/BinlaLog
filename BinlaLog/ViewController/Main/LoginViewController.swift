//
//  LoginViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 12/25/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var scrollView: ScrollView!
    @IBOutlet weak var vw_top: UIView!
    @IBOutlet weak var cons_height: NSLayoutConstraint!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var lb_app_name: UILabel!
    @IBOutlet weak var img_logo: UIImageView!
    @IBAction func btn_signin_action(_ sender: UIButton) {
        self.doSignin()
    }
    @IBOutlet weak var tf_password: NTextField!
    @IBOutlet weak var tf_username: NTextField!
    @IBAction func tf_username_change(_ sender: UITextField) {
        self.viewModel.username = sender.text!
    }
    @IBAction func tf_password_change(_ sender: UITextField) {
        self.viewModel.password = sender.text!
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 1, animations: {
            self.scrollView.frame.size.height -= 100
        })
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 1, animations: {
            self.scrollView.frame.size.height += 100
        })
    }
    var viewModel = ViewModel(){
        didSet{
            self.lb_app_name.watch(subject: self.viewModel.appname)
            self.img_logo.image = UIImage(named:self.viewModel.imglogo)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initApp()
        self.setUI()
    }
    func setUI(){
        self.btn_login.backgroundColor = Constant().getColorMain()
        self.tf_username.makeRectTextfield(color: UIColor(netHex:0xeeeeee))
        self.tf_password.makeRectTextfield(color: UIColor(netHex:0xeeeeee))
        self.img_logo.layer.cornerRadius = 5
        self.img_logo.layer.masksToBounds = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 1{
            self.doSignin()
        }
        return true
    }
}
extension LoginViewController{
    struct ViewModel {
        var appname : String = ""
        var imglogo : String = ""
        var username : String = ""
        var password : String = ""
    }
    func initApp(){
        self.viewModel.appname = Constant().getAppName()
        self.viewModel.imglogo = Constant().getLogo()
        
    }
}
