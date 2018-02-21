//
//  ProcedureTableViewCell.swift
//  BinlaLog
//
//  Created by Tanakorn on 22/1/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class ProcedureTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    var sender = ProcedureViewController()
    @IBOutlet weak var cons_tableView_height: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lb_procedure_group: UILabel!
    var procedures : Results<Procedure>?
    override func awakeFromNib() {
        super.awakeFromNib()
        
                // Initialization code
    }
    func setDelegate(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        self.cons_tableView_height.constant = self.tableView.contentSize.height
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.procedures != nil{
            return self.procedures!.count
        }else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProcedureInfoTableViewCell
        if indexPath.row < self.procedures!.count{
            switch procedures![indexPath.row].proctype {
            case 1:cell.vw_level.backgroundColor = Constant().getLvEasy()
            case 2:cell.vw_level.backgroundColor = Constant().getLvMedium()
            case 3:cell.vw_level.backgroundColor = Constant().getLvHard()
            default:
                cell.vw_level.backgroundColor = Constant().getLvEasy()
            }
            cell.lb_procedure.text = self.procedures![indexPath.row].name
            cell.btn_info.tag = indexPath.row
            if cell.isEnableInfo{
                cell.lb_des.text = self.procedures![indexPath.row].des
            }else{
                cell.lb_des.text = ""
            }
            let progress = BackRotation.getInstance().listLogbookProgress(procedureid: self.procedures![indexPath.row].id,rotationid: self.sender.rotationid)
            cell.lb_assist.text = "0"
            cell.lb_perform.text = "0"
            cell.lb_observe.text = "0"
            for i in 0..<progress.count{
                switch Array(progress.keys)[i]{
                case 1:cell.lb_assist.text = "\(Array(progress.values)[i])"
                case 2:cell.lb_perform.text = "\(Array(progress.values)[i])"
                case 0:cell.lb_observe.text = "\(Array(progress.values)[i])"
                default:
                    cell.lb_assist.text = "0"
                    cell.lb_perform.text = "0"
                    cell.lb_observe.text = "0"
                }
            }
            cell.tableView = self.tableView
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sender.procedureid = self.procedures![indexPath.row].id
        self.sender.performSegue(withIdentifier: "add", sender: self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
