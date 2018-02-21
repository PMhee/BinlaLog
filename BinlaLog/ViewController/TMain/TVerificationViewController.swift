//
//  TVerificationViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 31/1/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class TVerificationViewController: UIViewController {
    var timer = Timer()
    var seconds = 0
    
    @IBOutlet weak var btn_agian: UIButton!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var lb_code: UILabel!
    @IBAction func btn_cancel_action(_ sender: UIButton) {
        BackVerification.getInstance().cancelVerification {
            self.navigationController?.popViewController(animated: false)
        }
    }
    @IBAction func btn_time_edit_action(_ sender: UIButton) {
        self.showTimePicker(sender: sender)
    }
    @IBAction func btn_again_action(_ sender: UIButton) {
        self.btn_agian.isHidden = true
        self.newCode()
    }
    
    @IBOutlet weak var btn_cancel: UIButton!
    var viewModel = ViewModel(){
        didSet{
            self.lb_code.watch(subject: self.viewModel.code)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCode()
        self.runTimer()
    }
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        if seconds < 1 {
            self.timer.invalidate()
            self.btn_cancel.setTitle("Done", for: .normal)
            //self.navigationController?.popViewController(animated: false)
            //self.btn_agian.isHidden = false
        }else{
            seconds -= 1
            lb_time.text = timeString(time: TimeInterval(seconds))
        }
    }
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}
extension TVerificationViewController{
    struct ViewModel {
        var code : String = ""
    }
    func initCode(){
        //Check is verification axisting
        if let verification = BackVerification.getInstance().getTeacher(personid: BackUser.getInstance().get()!.id, date: Date()){
                self.seconds = Int(verification.expiretime.timeIntervalSince(Date()))
                self.viewModel.code = verification.verifycode
        }else{
            self.newCode()
        }
    }
    func newCode(){
        BackVerification.getInstance().requestVerification(expire: 5, finish: {
            self.initCode()
        })
    }
    func getCode(){
        BackVerification.getInstance().enumCode(finish: {
            self.initCode()
        },fail:{ (error) in
            if error == "notfound"{
                self.newCode()
            }else{
               Helper.addAlert(sender: self, title: "", message: "Internet connection error")
            }
            
        })
    }
    func editCode(expire:Int){
        BackVerification.getInstance().editVerification(expire: expire, finish: {
            self.initCode()
        })
    }
    func showTimePicker(sender:UIButton){
        let actionSheet = UIAlertController(title: "Time Picker", message: "Pick the verification timeout", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "1 Minute", style: .default, handler: {
            action in
            self.editCode(expire: 1)
        }))
        actionSheet.addAction(UIAlertAction(title: "5 Minutes", style: .default, handler: {
            action in
            self.editCode(expire: 5)
        }))
        actionSheet.addAction(UIAlertAction(title: "10 Minutes", style: .default, handler: {
            action in
            self.editCode(expire: 10)
        }))
        actionSheet.addAction(UIAlertAction(title: "15 Minutes", style: .default, handler: {
            action in
            self.editCode(expire: 15)
        }))
        actionSheet.addAction(UIAlertAction(title: "30 Minutes", style: .default, handler: {
            action in
            self.editCode(expire: 30)
        }))
        actionSheet.addAction(UIAlertAction(title: "1 hour", style: .default, handler: {
            action in
            self.editCode(expire: 60)
        }))
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.width, y: 0, width: sender.frame.width, height: sender.frame.height)
        self.present(actionSheet, animated: true, completion: nil)
    }
}
