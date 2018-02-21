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
    @IBOutlet weak var act: UIActivityIndicatorView!
    @IBAction func btn_add_procedure_action(_ sender: UIButton) {
        self.act.isHidden = false
        self.act.startAnimating()
        self.sender.addProcedure(tag:sender.tag / 2)
    }
    @IBAction func btn_add_patient_action(_ sender: UIButton) {
        self.sender.addPatient(tag:sender.tag / 2)
    }
    @IBOutlet weak var btn_add_procedure: UIButton!
    @IBOutlet weak var btn_add_patient: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
