//
//  FirstViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/3/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var img_logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
//        BackNotification.getInstance().cutDown(list: BackNotification.getInstance().listLogbook(), number: 200)
//        BackNotification.getInstance().cutDown(list: BackNotification.getInstance().listPatient(), number: 200)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.doCheckSession()
    }
    func setUI(){
        self.img_logo.layer.cornerRadius = 5
        self.img_logo.layer.masksToBounds = true
        self.img_logo.image = UIImage(named:Constant().getLogo())
    }
    func doLogout(){
        Helper.delay(2, closure: {
            BackUser.getInstance().removeAll()
            self.performSegue(withIdentifier: "doLogin", sender: self)
        })
    }
}
