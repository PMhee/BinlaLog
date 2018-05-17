//
//  QuestViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 25/4/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class QuestViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    //Variable
    var selectedTask = Task()
    var viewModel = ViewModel(){
        didSet{
            self.tableView.reload()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  self.initViewModel()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
    }
    func setUI(){
        func setUI(){
            if #available(iOS 11.0, *) {
                navigationController?.navigationBar.prefersLargeTitles = true
            } else {
                // Fallback on earlier versions
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "procedure"{
            if let top = segue.destination as? UINavigationController{
                if let des = top.topViewController as? ProcedureAddViewController{
                    var procedures = [String]()
                    for i in 0..<self.selectedTask.taskLogProcedure.count{
                        procedures.append(self.selectedTask.taskLogProcedure[i].procedureid)
                    }
                    des.procedureids = procedures
                    des.isTask = true
                    des.taskid = self.selectedTask.id
                    des.rotationid = BackUser.getInstance().get()?.currentSelectRotation ?? ""
                }
            }
        }else if segue.identifier == "attendance"{
            if let top = segue.destination as? UINavigationController{
                if let des = top.topViewController as? QuestAddViewController{
                    
                }
            }
        }
    }
}
extension QuestViewController{
    struct ViewModel {
        var quests = [Quest]()
    }
    func initViewModel(){
        BackCourse.getInstance().enumQuest(courseid: BackRotation.getInstance().get(id: BackUser.getInstance().get()?.currentSelectRotation ?? "")?.courseid ?? "",finish: {
            self.viewModel.quests = Array(BackCourse.getInstance().listQuest())
        })
        self.viewModel.quests = Array(BackCourse.getInstance().listQuest())
    }
}
extension QuestViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.quests.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let img = cell.viewWithTag(1) as! UIImageView
            let lb_quest = cell.viewWithTag(2) as! UILabel
            let lb_description = cell.viewWithTag(3) as! UILabel
            let lb_date_place = cell.viewWithTag(4) as! UILabel
            let lb_procedures = cell.viewWithTag(5) as! UILabel
            let lb_done = cell.viewWithTag(6) as! UILabel
            lb_description.font = lb_description.font.setItalic()
            lb_quest.text = self.viewModel.quests[indexPath.row].name
            lb_description.text = self.viewModel.quests[indexPath.row].des
            if let task = BackCourse.getInstance().getTask(id: self.viewModel.quests[indexPath.row].task.first?.taskid ?? ""){
                lb_date_place.text = (task.datetime?.convertToStringOnlyDate() ?? "" ) + (task.place.isEmpty ? "" : " at " + task.place)
                for i in 0..<task.taskLogProcedure.count{
                    if let procedure = BackProcedure.getInstance().get(id: task.taskLogProcedure[i].procedureid){
                        lb_procedures.text = (lb_procedures.text ?? "") + "・ \(procedure.name) \n"
                    }
                }
            }
            lb_done.text = "\(self.viewModel.quests[indexPath.row].questCount )/\(self.viewModel.quests[indexPath.row].questRequirement)"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "notfound", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.quests.count == 0 {
            return 1
        }else{
            return self.viewModel.quests.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.viewModel.quests.count > 0 {
            if let task = BackCourse.getInstance().getTask(id: self.viewModel.quests[indexPath.row].task.first?.taskid ?? ""){
                self.selectedTask = task
                if task.type == 2 {
                    self.performSegue(withIdentifier: "procedure", sender: self)
                }else if task.type == 1{
                    self.performSegue(withIdentifier: "attendance", sender: self)
                }
            }
        }
    }
}
