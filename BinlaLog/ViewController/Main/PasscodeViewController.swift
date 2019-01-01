//
//  PasscodeViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 12/6/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit
import LocalAuthentication
class PasscodeViewController: UIViewController {
    @IBAction func tf_passcode_change(_ sender: UITextField) {
        self.viewModel.passcode = sender.text!
    }
    
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var tf_passcode: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel = ViewModel(){
        didSet{
            self.collectionView.reloadData()
            if viewModel.passcode.count == 6 && !self.checkPasscode() && viewModel.rePasscode.isEmpty {
                viewModel.rePasscode = viewModel.passcode
                self.viewModel.passcode = ""
                self.lb_title.text = "Plese confirm your passcode"
            }else if !viewModel.rePasscode.isEmpty && viewModel.passcode.count == 6{
                if viewModel.rePasscode == viewModel.passcode {
                    BackUser.getInstance().putPasscode(viewModel: viewModel)
                    self.performSegue(withIdentifier: "success", sender: self)
                }else{
                    viewModel.rePasscode = ""
                    viewModel.passcode = ""
                    self.lb_title.text = "Passcode not match"
                }
            }else{
                if self.checkPasscode(){
                    if BackUser.getInstance().get()?.passcode ?? "" == self.viewModel.passcode{
                        self.performSegue(withIdentifier: "success", sender: self)
                    }else{
                        if viewModel.passcode.count == 6{
                            viewModel.passcode = ""
                            self.lb_title.text = "Wrong Passcode"
                        }
                    }
                }
            }
            self.tf_passcode.watch(subject: self.viewModel.passcode)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = Constant().getColorMain()
        self.collectionView.backgroundColor = Constant().getColorMain()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if BackUser.getInstance().get() == nil {
            self.performSegue(withIdentifier: "login", sender: self)
        }else{
            self.tf_passcode.becomeFirstResponder()
            self.checkPasscode() ? self.useTouchId() : ()
            self.lb_title.text = self.checkPasscode() ? "Enter Passcode or Touch ID" : "Please Enter New Passcode for \(Constant().getAppName())"
        }
        
    }
}
extension PasscodeViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let vw = cell.viewWithTag(1)
        vw?.layer.cornerRadius = 8
        vw?.layer.masksToBounds = true
        vw?.alpha = indexPath.row < self.viewModel.passcode.count ? 1 : 0.4
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
}
extension PasscodeViewController{
    struct ViewModel {
        var passcode : String = ""
        var rePasscode : String = ""
    }
    func checkPasscode() -> Bool{
        return !(BackUser.getInstance().get()?.passcode.isEmpty ?? false)
    }
    func useTouchId(){
        let context = LAContext()
        if #available(iOS 9.0, *) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "Please authenticate to proceed.") { [weak self] (success, error) in
                if success {
                    DispatchQueue.main.async {
                        self?.viewModel.passcode = "aaaaaa"
                        self?.performSegue(withIdentifier: "success", sender: self)
                        // show something here to block the user from continuing
                    }
                    
                    return
                }else {
                    
                    switch error {
                    case LAError.authenticationFailed?:
                        print("There was a problem verifying your identity.")
                        return
                    case LAError.userCancel?:
                        print("You pressed cancel.")
                        return
                    case LAError.userFallback?:
                        print("You pressed password.")
                    default:
                        print("Touch ID may not be configured")
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
