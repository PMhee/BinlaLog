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
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.doCheckSession()
    }
    func setUI(){
        self.img_logo.layer.cornerRadius = 5
        self.img_logo.layer.masksToBounds = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
