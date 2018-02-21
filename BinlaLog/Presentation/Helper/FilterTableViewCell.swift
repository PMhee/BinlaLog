//
//  FilterTableViewCell.swift
//  BinlaLog
//
//  Created by Tanakorn on 17/1/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell,TagListViewDelegate {

    @IBOutlet var lb_hide: UILabel!
    @IBOutlet var lb_header: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
