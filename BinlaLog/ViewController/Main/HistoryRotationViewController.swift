//
//  HistoryRotationViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/4/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class HistoryRotationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //Route
    var key : String = ""{
        didSet{
            print(key)
        }
    }
    //Variable
    var index = 0
    var isLoading = false
    @IBOutlet weak var tableView: UITableView!
    var viewModel = ViewModel(){
        didSet{
            //self.tableView.reloadData()
        }
    }
    var staticProcedure = [LogbookProcedure]()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(doSearchProcedure), name: .textChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isDelete), name: .isDelete, object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initViewModel()
        self.loadTop {
            
            }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.logbookProcedure.count == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "notfound", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let vw_level = cell.viewWithTag(1)
            let lb_procedure_name = cell.viewWithTag(2) as! UILabel
            let img_emotion = cell.viewWithTag(3) as! UIImageView
            let lb_date = cell.viewWithTag(4) as! UILabel
            let lb_verification = cell.viewWithTag(5) as! UILabel
            let vw_message = cell.viewWithTag(6)
            vw_message?.isHidden = true
            vw_message?.layer.cornerRadius = 3
            vw_message?.layer.masksToBounds = true
            if self.viewModel.logbookProcedure[indexPath.row].logbook?.verifymessage ?? "" != ""{
                vw_message?.isHidden = false
            }
            if let logbook = self.viewModel.logbookProcedure[indexPath.row].logbook{
                switch logbook.verificationstatus{
                case 0 :
                    lb_verification.text = "Pending"
                    lb_verification.textColor = UIColor.lightGray
                case 1 :
                    lb_verification.text = "Accepted"
                    lb_verification.textColor = UIColor(netHex:0x63D79F)
                case 2 :
                    lb_verification.text = "Accepted"
                    lb_verification.textColor = UIColor(netHex:0x63D79F)
                case -1:
                    lb_verification.text = "Rejected"
                    lb_verification.textColor = UIColor(netHex:0xD93829)
                default:
                    lb_verification.text = "Pending"
                    lb_verification.textColor = UIColor.lightGray
                }
                switch logbook.feeling{
                case 0:img_emotion.image = UIImage(named:"emotion-angry-grey.png")
                case 1:img_emotion.image = UIImage(named:"emotion-crying-grey.png")
                case 2:img_emotion.image = UIImage(named:"emotion-straight-grey.png")
                case 3:img_emotion.image = UIImage(named:"emotion-smile-grey.png")
                case 4:img_emotion.image = UIImage(named:"emotion-love-grey.png")
                default: print()
                }
                switch logbook.logtype{
                case 0:lb_date.text = Date().recent(from: logbook.updatetime) + " as Observer"
                case 1:lb_date.text = Date().recent(from: logbook.updatetime) + " as Assistant"
                case 2:lb_date.text =  Date().recent(from: logbook.updatetime) + " as Performer"
                default:lb_date.text = Date().recent(from: logbook.updatetime)
                }
                
            }
            if  let procedure = self.viewModel.logbookProcedure[indexPath.row].procedure{
                switch procedure.proctype{
                case 1:
                    vw_level?.backgroundColor = Constant().getLvEasy()
                case 2:
                    vw_level?.backgroundColor = Constant().getLvMedium()
                case 3:
                    vw_level?.backgroundColor = Constant().getLvHard()
                default: print()
                }
                lb_procedure_name.text = procedure.name
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.viewModel.logbookProcedure.count > 0 {
            self.index = indexPath.row
            self.performSegue(withIdentifier: "edit", sender: self)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Helper.showLoading(sender: self)
            BackRotation.getInstance().deleteLogbook(logbookid: self.viewModel.logbookProcedure[indexPath.row].logbook?.id ?? "", finish: {
                self.viewModel.logbookProcedure.remove(at: indexPath.row)
                self.dismiss(animated: false, completion: nil)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.logbookProcedure.count == 0{
            return 1
        }else{
            return self.viewModel.logbookProcedure.count
        }
    }
}
extension HistoryRotationViewController{
    struct ViewModel {
        var logbookProcedure = [LogbookProcedure]()
        var rotationid: String!
    }
    struct LogbookProcedure{
        var logbook : Logbook?
        var procedure : Procedure?
    }
    @objc func isDelete(notification:Notification){
        self.tableView.isEditing = !self.tableView.isEditing
    }
    @objc func doSearchProcedure(notification:Notification){
        if let key = notification.userInfo?["text"] as? String{
            self.viewModel.logbookProcedure = self.staticProcedure
            if !key.isEmpty{
                self.viewModel.logbookProcedure = self.viewModel.logbookProcedure.filter {
                    if let procedure = $0.procedure{
                        return procedure.name.lowercased().contains(key.lowercased())
                    }else{
                        return false
                    }
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
    func initViewModel(){
        self.viewModel.rotationid = BackUser.getInstance().get()!.currentSelectRotation
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"{
            if let navigation = segue.destination as? UINavigationController{
                if let des = navigation.topViewController as? ProcedureAddViewController{
                    des.isEnableEditing = false
                    des.logbookid = self.viewModel.logbookProcedure[self.index].logbook?.id ?? ""
                }
            }
        }
    }
}
extension HistoryRotationViewController:NViewControllerDelegate{
    func loadBottom(success: @escaping () -> Void) {
        success()
    }
    func loadTop(success:@escaping () -> Void){
        self.isLoading = true
        BackRotation.getInstance().EnumLogbook(updatetime: BackRotation.getInstance().getLogbookLastUpdateTime(rotationid: BackUser.getInstance().get()!.currentSelectRotation), rotationid: BackUser.getInstance().get()!.currentSelectRotation, finish: {
            self.joinLogbookProcedure(logbooks: BackRotation.getInstance().listLogbook(rotationid: self.viewModel.rotationid))
            self.isLoading = false
            success()
        })
        self.joinLogbookProcedure(logbooks: BackRotation.getInstance().listLogbook(rotationid: self.viewModel.rotationid))
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        Helper.tableViewLoading(sender: self, tableView: self.tableView, offset: scrollView.contentOffset.y, isLoading: self.isLoading)
    }
}
