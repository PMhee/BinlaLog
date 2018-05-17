//
//  CommentViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 14/2/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController,UITextViewDelegate {
    @IBAction func btn_accept_action(_ sender: UIButton) {
        if !(self.viewModel?.message ?? "" == "" ){
            self.viewModel?.verifystatus = 2
        }else{
            self.viewModel?.verifystatus = 1
        }
        if self.isPatient{
            BackNotification.getInstance().updatePatientComment(viewModel: self.viewModelPatient!, finish: {
                self.dismiss(animated: true, completion: nil)
            })
        }else{
            BackNotification.getInstance().updateProcedureComment(viewModel: self.viewModel!, finish: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    @IBAction func btn_reject_action(_ sender: UIButton) {
        self.viewModel?.verifystatus = -1
        if self.isPatient{
            BackNotification.getInstance().updatePatientComment(viewModel: self.viewModelPatient!, finish: {
                self.dismiss(animated: true, completion: nil)
            })
        }else{
            BackNotification.getInstance().updateProcedureComment(viewModel: self.viewModel!, finish: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @IBOutlet weak var lb_placeholder: UILabel!
    @IBOutlet weak var tv_comment: UITextView!
    var viewModel : ProcedureAddViewController.ViewModel?
    var viewModelPatient : PatientViewController.ViewModel?
    var isPatient = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tv_comment.becomeFirstResponder()
        if self.isPatient{
            self.tv_comment.text = self.viewModelPatient?.message ?? ""
            if self.viewModelPatient?.message ?? "" != ""{
                self.lb_placeholder.isHidden = true
            }
        }else{
            self.tv_comment.text = self.viewModel?.message ?? ""
            if self.viewModel?.message ?? "" != ""{
                self.lb_placeholder.isHidden = true
            }
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty{
            self.lb_placeholder.isHidden = false
        }else{
            self.lb_placeholder.isHidden = true
        }
        if self.isPatient{
            self.viewModelPatient?.message = textView.text!
        }else{
            self.viewModel?.message = textView.text!
        }
    }
}
