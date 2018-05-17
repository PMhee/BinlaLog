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
    @IBOutlet weak var btn_forgot: UIButton!
    @IBOutlet weak var tf_password: NTextField!
    @IBOutlet weak var tf_username: NTextField!
    @IBAction func tf_username_change(_ sender: UITextField) {
        self.viewModel.username = sender.text!
    }
    @IBAction func tf_password_change(_ sender: UITextField) {
        self.viewModel.password = sender.text!
    }
    @IBAction func btn_forgot_action(_ sender: UIButton) {
        #if BINLALOG
        let alert = UIAlertController(title: "Please contact Admin", message: "074-451-5333", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Call", style: .default, handler: {(action) in
            guard let number = URL(string: "tel://0744515333") else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(number)
            } else {
                // Fallback on earlier versions
            }
        }))
        self.present(alert, animated: true)
        #endif
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
        self.btn_forgot.setTitleColor(Constant().getColorMain(), for: .normal)
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
