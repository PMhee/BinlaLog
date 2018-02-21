//
//  TNotificationViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 13/2/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class TProcedureNotificationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var index = 0
    var isLoading = false
    var staticProcedure = [LogbookProcedure]()
    var viewModel = ViewModel(){
        didSet{
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(doSearchProcedure), name: .textChange, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadTop {
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show"{
            if let nav = segue.destination as? UINavigationController{
                if let des = nav.topViewController as? ProcedureAddViewController{
                    des.logbookid = self.viewModel.logbookProcedure[self.index].logbook?.id ?? ""
                    des.isTeacher = true
                    des.isEnableEditing = false
                }
            }
        }
    }
}
extension TProcedureNotificationViewController{
    struct ViewModel {
        var logbookProcedure = [LogbookProcedure]()
    }
    struct LogbookProcedure {
        var logbook : Logbook?
        var procedure : Procedure?
    }
    @objc func doSearchProcedure(notification:Notification){
        if let key = notification.userInfo?["text"] as? String{
            self.viewModel.logbookProcedure = self.staticProcedure
            if !key.isEmpty{
                self.viewModel.logbookProcedure = self.viewModel.logbookProcedure.filter {
                    var logic = false
                    if let procedure = $0.procedure{
                        logic = procedure.name.lowercased().contains(key.lowercased())
                        if logic{
                            return logic
                        }
                    }else{
                        logic = false
                    }
                    if let logbook = $0.logbook{
                        if let user = BackUser.getInstance().getPerson(id: logbook.lbuserid){
                            logic = user.firstname.lowercased().contains(key.lowercased()) || user.lastname.lowercased().contains(key.lowercased()) || user.studentid.lowercased().contains(key.lowercased())
                            if logic{
                                return logic
                            }
                        }else{
                            logic = false
                        }
                    }else{
                        logic = false
                    }
                    return logic
                }
            }
            self.tableView.reloadData()
        }
    }
    func joinLogbookProcedure(logbooks:Results<Logbook>){
        self.viewModel.logbookProcedure = []
        for i in 0..<logbooks.count{
            let logbook = logbooks[i]
            if let procedure = BackProcedure.getInstance().get(id: logbook.procedureid){
                var lbpc = LogbookProcedure()
                lbpc.logbook = logbook
                lbpc.procedure = procedure
                self.viewModel.logbookProcedure.append(lbpc)
            }
        }
        self.staticProcedure = self.viewModel.logbookProcedure
        self.tableView.reloadData()
    }
}
extension TProcedureNotificationViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.logbookProcedure.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notfound", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let img_profile = cell.viewWithTag(1) as! UIImageView
            let lb_profile = cell.viewWithTag(2) as! UILabel
            let lb_date = cell.viewWithTag(3) as! UILabel
            let lb_procedure = cell.viewWithTag(4) as! UILabel
            Helper.loadLocalImage(id: self.viewModel.logbookProcedure[indexPath.row].logbook?.lbuserid ?? "", image: img_profile)
            if let user = BackUser.getInstance().getPerson(id: self.viewModel.logbookProcedure[indexPath.row].logbook?.lbuserid ?? ""){
                lb_profile.text = user.firstname + " " + user.lastname + " " + user.studentid
            }
            lb_date.text = Date().recent(from: (self.viewModel.logbookProcedure[indexPath.row].logbook?.verifytime)!)
            if let procedure = self.viewModel.logbookProcedure[indexPath.row].procedure{
                lb_procedure.text = procedure.name
            }
            img_profile.layer.cornerRadius = 2
            img_profile.layer.masksToBounds = true
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.logbookProcedure.count == 0{
            return 1
        }else{
            return self.viewModel.logbookProcedure.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.logbookProcedure.count > 0 {
            self.index = indexPath.row
            self.performSegue(withIdentifier: "show", sender: self)
        }
    }
}
extension TProcedureNotificationViewController:NViewControllerDelegate{
    func loadBottom(success: @escaping () -> Void) {
        if self.viewModel.logbookProcedure.count >= 100{
            BackNotification.getInstance().enumBeforeNotification {
                self.joinLogbookProcedure(logbooks: BackRotation.getInstance().listLogbook())
                self.isLoading = false
                success()
            }
            self.joinLogbookProcedure(logbooks: BackRotation.getInstance().listLogbook())
        }else{
            self.isLoading = false
            success()
        }
    }
    func loadTop(success:@escaping () -> Void){
        BackNotification.getInstance().enumNotification {
            self.joinLogbookProcedure(logbooks: BackRotation.getInstance().listLogbook())
            self.isLoading = false
            success()
        }
        self.joinLogbookProcedure(logbooks: BackRotation.getInstance().listLogbook())
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isAtTop && !self.isLoading{
            self.isLoading = true
            self.tableView.tableHeaderView = Helper.getSpinner(sender: self.tableView)
            self.loadTop {
                self.tableView.tableHeaderView = nil
            }
        }else if scrollView.isAtBottom && !self.isLoading{
            self.isLoading = true
            self.tableView.tableFooterView = Helper.getSpinner(sender: self.tableView)
            self.loadBottom {
                self.tableView.tableFooterView = nil
            }
        }
    }
}
