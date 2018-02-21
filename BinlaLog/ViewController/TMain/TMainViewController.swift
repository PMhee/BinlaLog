//
//  TMainViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 31/1/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class TMainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func btn_logout_action(_ sender: UIButton) {
        self.doLogout()
    }
    let more = ["Get a verification code","Notification","Contact","Logout"]
    let pic = ["ic-code.png","ic-noti.png","ic-facebook.png","ic-logout.png"]
    var viewModel = ViewModel(){
        didSet{
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUser()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "notification"{
            if let des = segue.destination as? HistoryViewController{
                des.isTeacher = true
            }
        }
    }
}
extension TMainViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "profile", for: indexPath)
            let lb = cell.viewWithTag(1) as! UILabel
            let img = cell.viewWithTag(2) as! UIImageView
            Helper.loadLocalImage(id: BackUser.getInstance().get()?.id ?? "", success: {(image) in
                img.image = image
            })
            lb.text = self.viewModel.user?.firstname ?? ""
            img.layer.cornerRadius = 30
            img.layer.masksToBounds = true
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let img = cell.viewWithTag(1) as! UIImageView
            let lb = cell.viewWithTag(2) as! UILabel
            img.image = UIImage(named:self.pic[indexPath.row-1])
            lb.text = self.more[indexPath.row-1]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.more.count+1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0{
            self.performSegue(withIdentifier: "profile", sender: self)
        }else if indexPath.row == 1 {
           self.performSegue(withIdentifier: "getCode", sender: self)
        }else if indexPath.row == 2{
            self.performSegue(withIdentifier: "notification", sender: self)
        }else if indexPath.row == 3{
            UIApplication.shared.openURL(URL(string: Constant().getFacebookURL())!)
        }else if indexPath.row == 4 {
            self.doLogout()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
extension TMainViewController{
    struct ViewModel {
        var user : User?
    }
    func initUser(){
        BackUser.getInstance().getUserInfo {
            self.viewModel.user = BackUser.getInstance().get()
        }
        self.viewModel.user = BackUser.getInstance().get()
    }
    func doLogout(){
        Helper.showLoading(sender: self)
        Helper.delay(2, closure: {
            self.dismiss(animated: false, completion: nil)
            BackUser.getInstance().removeAll()
            self.performSegue(withIdentifier: "logout", sender: self)
        })
    }
}
