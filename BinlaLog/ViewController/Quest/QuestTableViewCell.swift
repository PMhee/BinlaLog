//
//  QuestTableViewCell.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/6/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class QuestTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var const_table_height: NSLayoutConstraint!
    @IBOutlet weak var lb_header: UILabel!
    @IBOutlet weak var lb_des: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var view = QuestViewController()
    var task = [ForeignTask]()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setDeletegate(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        self.const_table_height.constant = self.tableView.contentSize.height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lb = cell.viewWithTag(1) as! UILabel
        let lb_date_place = cell.viewWithTag(2) as! UILabel
        let img = cell.viewWithTag(3) as! UIImageView
        let lb_no = cell.viewWithTag(4) as! UILabel
        if let task = BackCourse.getInstance().getTask(id: self.task[indexPath.row].taskid){
            lb.text = task.name
            lb_date_place.text = (task.datetime?.convertToStringOnlyDate() ?? "" ) + (task.place.isEmpty ? "" : " at " + task.place)
            img.image = UIImage(named: task.type == 1 ? "ic-code.png" : "ic-virus.png" )
            lb_no.text = String(task.noLog)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.task.count
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        NotificationCenter.default.post(name: .selectTask, object: nil, userInfo: ["id":self.task[indexPath.row].taskid])
    }
}
