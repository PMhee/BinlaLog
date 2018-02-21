//
//  ProcedureInfoTableViewCell.swift
//  BinlaLog
//
//  Created by Tanakorn on 22/1/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class ProcedureInfoTableViewCell: UITableViewCell {
    var tableView = UITableView()
    @IBOutlet weak var btn_info: UIButton!
    @IBOutlet weak var lb_des: UILabel!
    @IBOutlet weak var lb_assist: UILabel!
    @IBOutlet weak var lb_perform: UILabel!
    @IBOutlet weak var lb_observe: UILabel!
    @IBOutlet weak var vw_level: UIView!
    @IBOutlet weak var lb_procedure: UILabel!
    var isEnableInfo : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func btn_info_action(_ sender: UIButton) {
        if self.isEnableInfo{
            self.isEnableInfo = false
        }else{
            self.isEnableInfo = true
        }
        self.tableView.reloadRows(at: [IndexPath(row:sender.tag,section:0)], with: .automatic)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
