//
//  PickerViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 4/4/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {
    //Routing
    var arr = [String]()
    
    
    var index = 0
    
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBAction func btn_cancel_action(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_confirm_action(_ sender: UIButton) {
        if self.viewModel.arr.count > self.index{
        NotificationCenter.default.post(name: .pickerChange, object: nil, userInfo: ["data":self.viewModel.arr[self.index]])
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var picker: UIPickerView!
    var viewModel = ViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewModel()
        self.setUI()
    }
    func setUI(){
        self.btn_cancel.layer.cornerRadius = 2
        self.btn_confirm.layer.cornerRadius = 2
        self.btn_cancel.layer.borderWidth = 1
        self.btn_cancel.layer.borderColor = Constant().getColorMain().cgColor
        self.btn_cancel.setTitleColor(Constant().getColorMain(), for: .normal)
        self.btn_confirm.backgroundColor = Constant().getColorMain()
    }
}
extension PickerViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    struct ViewModel {
        var arr = [String]()
    }
    func initViewModel(){
        self.viewModel.arr = arr
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewModel.arr[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.arr.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.index = row
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
