
//
//  DatePickerViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/9/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBAction func btn_cancel_action(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func btn_confirm_action(_ sender: UIButton) {
        if self.restrictDate != nil{
            if self.datePicker.date < self.restrictDate!{
                NotificationCenter.default.post(name: .dateChange, object: nil, userInfo: ["date":self.datePicker.date])
                self.dismiss(animated: false, completion: nil)
            }else{
                Helper.showWarning(sender: self, text: "date cannot be late that deadline")
            }
        }else{
            NotificationCenter.default.post(name: .dateChange, object: nil, userInfo: ["date":self.datePicker.date])
            self.dismiss(animated: false, completion: nil)
        }
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_confirm: UIButton!
    private var date = Date()
    private var restrictDate : Date?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    func initView(){
        self.datePicker.date = self.date
    }
    func setDate(date:Date){
        self.date = date
    }
    func setRestrictedDate(date:Date){
        self.restrictDate = date
    }
    func getDate() ->Date{
        return self.date
    }
    func setUI(){
        self.btn_cancel.layer.cornerRadius = 2
        self.btn_confirm.layer.cornerRadius = 2
        self.btn_cancel.layer.borderWidth = 1
        self.btn_cancel.layer.borderColor = Constant().getColorMain().cgColor
        self.btn_cancel.setTitleColor(Constant().getColorMain(), for: .normal)
        self.btn_confirm.backgroundColor = Constant().getColorMain()
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
