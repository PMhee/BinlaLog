//
//  SummaryProcedureViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 23/1/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class SummaryProcedureViewController: UIViewController {
    //Routing
    var rotationid : String = ""
    var procedureid : String = ""
    var isEnableEditing : Bool = true
    //Variable
    var index = 0
    @IBOutlet weak var lb_procedure: UILabel!
    
    @IBOutlet weak var lb_procedure_group: UILabel!
    @IBOutlet weak var img_level: UIImageView!
    @IBOutlet weak var lb_level: UILabel!
    @IBOutlet weak var lb_observe: UILabel!
    @IBOutlet weak var lb_assist: UILabel!
    @IBOutlet weak var lb_perform: UILabel!
    @IBOutlet weak var progress_angry: UIProgressView!
    @IBOutlet weak var progress_cry: UIProgressView!
    @IBOutlet weak var progress_straight: UIProgressView!
    @IBOutlet weak var progress_smile: UIProgressView!
    @IBOutlet weak var progress_love: UIProgressView!
    @IBOutlet weak var lb_progress_angry: UILabel!
    @IBOutlet weak var lb_progress_cry: UILabel!
    @IBOutlet weak var lb_progress_smile: UILabel!
    @IBOutlet weak var lb_progress_love: UILabel!
    @IBOutlet weak var lb_progress_straight: UILabel!
    @IBOutlet weak var tableviewHistory: UITableView!
    @IBOutlet weak var cons_height_tableView_history: NSLayoutConstraint!
    
    @IBAction func btn_cancel_action(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    var viewModel = ViewModel(){
        didSet{
            if let procedure = self.viewModel.procedure{
                lb_procedure.watch(subject: procedure.name)
                if let group = BackProcedure.getInstance().getGroup(id: procedure.proceduregroup){
                    print(group)
                    lb_procedure_group.watch(subject: group.procgroupname)
                }
                switch procedure.proctype{
                case 1:img_level.image = UIImage(named:"ic-level-easy.png")
                    lb_level.text = "Basic"
                case 2:img_level.image = UIImage(named:"ic-level-medium.png")
                    lb_level.text = "Important"
                case 3:img_level.image = UIImage(named:"ic-level-hard.png")
                    lb_level.text = "Advanced"
                default:img_level.image = UIImage(named:"ic-level-easy.png")
                    lb_level.text = "Basic"
                }
                let done = BackRotation.getInstance().listLogbookProgress(procedureid: procedure.id, rotationid: self.rotationid)
                lb_observe.text = "0"
                lb_assist.text = "0"
                lb_perform.text = "0"
                var done_time = 0
                for i in 0..<done.count{
                    done_time += Array(done.values)[i]
                    switch Array(done.keys)[i]{
                    case 0:lb_observe.text = String(Array(done.values)[i])
                    case 1:lb_assist.text = String(Array(done.values)[i])
                    case 2:lb_perform.text = String(Array(done.values)[i])
                    default:lb_observe.text = "0"
                        lb_assist.text = "0"
                        lb_perform.text = "0"
                    }
                }
                self.progress_angry.progress = 0
                self.progress_cry.progress = 0
                self.progress_straight.progress = 0
                self.progress_smile.progress = 0
                self.progress_love.progress = 0
                self.lb_progress_angry.text = "0.00 %"
                self.lb_progress_cry.text = "0.00 %"
                self.lb_progress_straight.text = "0.00 %"
                self.lb_progress_smile.text = "0.00 %"
                self.lb_progress_love.text = "0.00 %"
                for i in 0..<self.viewModel.emotion.count{
                    switch Array(self.viewModel.emotion.keys)[i]{
                    case 0:self.progress_angry.progress = Float(Array(self.viewModel.emotion.values)[i])/Float(done_time)
                    self.lb_progress_angry.text = String(format:"%.2f",Float(Array(self.viewModel.emotion.values)[i])/Float(done_time)*100) + " %"
                    case 1:self.progress_cry.progress = Float(Array(self.viewModel.emotion.values)[i])/Float(done_time)
                        self.lb_progress_cry.text = String(format:"%.2f",Float(Array(self.viewModel.emotion.values)[i])/Float(done_time)*100) + " %"
                    case 2:self.progress_straight.progress = Float(Array(self.viewModel.emotion.values)[i])/Float(done_time)
                        self.lb_progress_straight.text = String(format:"%.2f",Float(Array(self.viewModel.emotion.values)[i])/Float(done_time)*100) + " %"
                    case 3:self.progress_smile.progress = Float(Array(self.viewModel.emotion.values)[i])/Float(done_time)
                        self.lb_progress_smile.text = String(format:"%.2f",Float(Array(self.viewModel.emotion.values)[i])/Float(done_time)*100) + " %"
                    case 4:self.progress_love.progress = Float(Array(self.viewModel.emotion.values)[i])/Float(done_time)
                        self.lb_progress_love.text = String(format:"%.2f",Float(Array(self.viewModel.emotion.values)[i])/Float(done_time)*100) + " %"
                    default:self.progress_angry.progress = Float(Array(self.viewModel.emotion.values)[i])/Float(done_time)
                        self.lb_progress_angry.text = String(format:"%.2f",Float(Array(self.viewModel.emotion.values)[i])/Float(done_time)*100) + " %"
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initProcedure()
        self.initEmotion()
        self.initLogbook()
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableviewHistory.reloadData()
        self.tableviewHistory.layoutIfNeeded()
        if self.viewModel.logbooks != nil{
            self.cons_height_tableView_history.constant = CGFloat(60*self.viewModel.logbooks!.count)
        }else{
            self.cons_height_tableView_history.constant = 0
        }
    }
    func setUI(){
        self.progress_angry.progressTintColor = Constant().getColorMain()
        self.progress_cry.progressTintColor = Constant().getColorMain()
        self.progress_straight.progressTintColor = Constant().getColorMain()
        self.progress_smile.progressTintColor = Constant().getColorMain()
        self.progress_love.progressTintColor = Constant().getColorMain()
    }
}
extension SummaryProcedureViewController{
    struct ViewModel {
        var procedure : Procedure?
        var emotion = [Int:Int]()
        var logbooks : Results<Logbook>?
    }
    func initProcedure(){
        self.viewModel.procedure = BackProcedure.getInstance().get(id: self.procedureid)
    }
    func initEmotion(){
        self.viewModel.emotion = BackRotation.getInstance().summaryEmotion(rotationid: self.rotationid, procedureid: self.procedureid)
    }
    func initLogbook(){
        if self.rotationid == ""{
            self.viewModel.logbooks = BackRotation.getInstance().listLogbook(procedureid: self.procedureid)
        }else{
            self.viewModel.logbooks = BackRotation.getInstance().listLogbook(rotationid: self.rotationid, procedureid: self.procedureid)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController{
            if let des = nav.topViewController as? ProcedureAddViewController{
                des.isEnableEditing = false
                des.procedureid = self.procedureid
                des.logbookid = self.viewModel.logbooks![self.index].id
            }
        }
    }
}
extension SummaryProcedureViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.logbooks == nil{
            let cell = tableView.dequeueReusableCell(withIdentifier: "notfound", for: indexPath)
            return cell
        }else{
            if self.viewModel.logbooks!.count == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "notfound", for: indexPath)
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                let img_emotion = cell.viewWithTag(3) as! UIImageView
                let lb_date = cell.viewWithTag(4) as! UILabel
                let lb_verification = cell.viewWithTag(5) as! UILabel
                let lb_patienttype = cell.viewWithTag(6) as! UILabel
                if !self.isEnableEditing{
                    cell.selectionStyle = .none
                }
                if let logbooks = self.viewModel.logbooks{
                    switch logbooks[indexPath.row].verificationstatus{
                    case 0 :
                        lb_verification.text = "Pending"
                        lb_verification.textColor = UIColor.lightGray
                    case 1 :
                        lb_verification.text = "Accepted"
                        lb_verification.textColor = UIColor(netHex:0x63D79F)
                    case 2:
                        lb_verification.text = "Rejected"
                        lb_verification.textColor = UIColor(netHex:0xD93829)
                    default:
                        lb_verification.text = "Pending"
                        lb_verification.textColor = UIColor.lightGray
                    }
                    switch logbooks[indexPath.row].feeling{
                    case 0:img_emotion.image = UIImage(named:"emotion-angry-grey.png")
                    case 1:img_emotion.image = UIImage(named:"emotion-crying-grey.png")
                    case 2:img_emotion.image = UIImage(named:"emotion-straight-grey.png")
                    case 3:img_emotion.image = UIImage(named:"emotion-smile-grey.png")
                    case 4:img_emotion.image = UIImage(named:"emotion-love-grey.png")
                    default: print()
                    }
                    switch logbooks[indexPath.row].patienttype{
                    case 0:lb_patienttype.text = "IPD"
                    case 1:lb_patienttype.text = "OPD"
                    case 2:lb_patienttype.text = "SIM"
                    default:print()
                    }
                    switch logbooks[indexPath.row].logtype{
                    case 0:lb_date.text = Date().recent(from: logbooks[indexPath.row].updatetime) + " as Observer"
                    case 1:lb_date.text = Date().recent(from: logbooks[indexPath.row].updatetime) + " as Assistant"
                    case 2:lb_date.text = Date().recent(from: logbooks[indexPath.row].updatetime) + " as Performer"
                    default:lb_date.text = Date().recent(from: logbooks[indexPath.row].updatetime)
                    }
                }
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.isEnableEditing{
            if self.viewModel.logbooks != nil{
                if self.viewModel.logbooks!.count > 0 {
                    self.index = indexPath.row
                    self.performSegue(withIdentifier: "edit", sender: self)
                }
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.logbooks == nil{
            return 0
        }else{
            return self.viewModel.logbooks!.count
        }
    }
}
