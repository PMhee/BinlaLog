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
        self.addObserver()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initViewModel()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reload()
        self.tableView.layoutIfNeeded()
    }
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(onSelectTask), name: .selectTask, object: nil)
    }
    @objc func onSelectTask(notification:Notification){
        if let id = notification.userInfo?["id"] as? String{
            if let task = BackCourse.getInstance().getTask(id: id){
                self.selectedTask = task
                if task.type == 2 {
                    self.performSegue(withIdentifier: "procedure", sender: self)
                }else if task.type == 1{
                    self.performSegue(withIdentifier: "attendance", sender: self)
                }
            }
        }
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
                    des.questid = self.selectedTask.questid
                    des.rotationid = BackUser.getInstance().get()?.currentSelectRotation ?? ""
                }
            }
        }else if segue.identifier == "attendance"{
            if let top = segue.destination as? UINavigationController{
                if let des = top.topViewController as? QuestAddViewController{
                    des.task = self.selectedTask
                    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "quest", for: indexPath) as! QuestTableViewCell
            cell.selectionStyle = .none
            cell.lb_des.font = cell.lb_des.font.setItalic()
            cell.lb_header.text = self.viewModel.quests[indexPath.row].name
            cell.lb_des.text = self.viewModel.quests[indexPath.row].des
            cell.task = Array(self.viewModel.quests[indexPath.row].task)
            cell.view = self
            cell.setDeletegate()
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
}
