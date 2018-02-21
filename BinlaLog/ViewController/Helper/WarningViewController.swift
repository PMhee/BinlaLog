//
//  WarningViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/10/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class WarningViewController: UIViewController {

    @IBOutlet weak var lb_warning: UILabel!
    var viewModel = ViewModel(){
        didSet{
            guard let text = viewModel.warningText else {
                return
            }
            self.lb_warning.watch(subject: text)
        }
    }
    var warningText : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ViewModel(warningText: self.warningText)
        Helper.delay(2, closure: {
            self.dismiss(animated: false, completion: nil)
        })
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension WarningViewController{
    struct ViewModel {
        var warningText : String?
    }
}
extension WarningViewController.ViewModel{
    init(warningText:String="") {
        self.warningText = warningText
    }
}
