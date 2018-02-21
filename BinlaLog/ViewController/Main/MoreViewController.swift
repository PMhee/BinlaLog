//
//  MoreViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/3/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let more = ["Achievement","Contact","Logout"]
    let pic = ["ic-star.png","ic-facebook.png","ic-logout.png"]
    @IBOutlet weak var tableView: UITableView!
    var viewModel = ViewModel(){
        didSet{
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initUser()
        self.initRank()
        self.setUI()
    }
    func setUI(){
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "profile", for: indexPath)
            let lb_name = cell.viewWithTag(1) as! UILabel
            let img_profile = cell.viewWithTag(2) as! UIImageView
            if let user = self.viewModel.user{
                lb_name.text = user.firstname
                Helper.loadLocalImage(id: user.id, success: {(image) in
                    img_profile.image = image
                })
                img_profile.layer.cornerRadius = 30
                img_profile.layer.masksToBounds = true
            }
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "rank", for: indexPath)
            let vw_progress = cell.viewWithTag(1) as! UIProgressView
            let lb_rank = cell.viewWithTag(2) as! UILabel
            vw_progress.progressTintColor = Constant().getColorMain()
            vw_progress.progress = self.viewModel.rank ?? 0
            lb_rank.text = "Rank \(self.viewModel.yourRank ?? 0)/\(self.viewModel.noStudent ?? 0)"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let img = cell.viewWithTag(1) as! UIImageView
            let lb = cell.viewWithTag(2) as! UILabel
            img.image = UIImage(named:self.pic[indexPath.row-2])
            lb.text = self.more[indexPath.row-2]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.more.count+2
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            self.performSegue(withIdentifier: "profile", sender: self)
        }else if indexPath.row == 1{
            self.performSegue(withIdentifier: "rank", sender: self)
        }else if indexPath.row == 2{
            self.performSegue(withIdentifier: "achievement", sender: self)
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
extension MoreViewController{
    struct ViewModel {
        var user : User?
        var rank : Float?
        var yourRank : Int?
        var noStudent : Int?
    }
    func initUser(){
        BackUser.getInstance().getUserInfo {
            self.viewModel.user = BackUser.getInstance().get()
        }
        self.viewModel.user = BackUser.getInstance().get()
    }
    func initRank(){
        BackUser.getInstance().getMyRank(finish: {(dict) in
            var rank = 0
            var student = 0
            if let yourRank = dict.value(forKey: "yourRank") as? Int{
                rank = yourRank
                self.viewModel.yourRank = yourRank
            }
            if let noStudent = dict.value(forKey: "noStudent") as? Int{
                student = noStudent
                self.viewModel.noStudent = noStudent
            }
            rank -= 1
            rank = student - rank
            self.viewModel.rank = Float(rank) / Float(student)
        })
    }
}
