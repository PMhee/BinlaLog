//
//  HomeCellTableViewCell.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/5/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class HomeCellTableViewCell: UITableViewCell {
    var sender = HomeViewController()
    @IBOutlet weak var img_rotation: UIImageView!
    @IBOutlet weak var lb_rotation_name: UILabel!
    @IBOutlet weak var lb_rotation_date: UILabel!
    @IBAction func btn_add_procedure_action(_ sender: UIButton) {
        self.sender.addProcedure()
    }
    @IBAction func btn_add_patient_action(_ sender: UIButton) {
        self.sender.addPatient()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
