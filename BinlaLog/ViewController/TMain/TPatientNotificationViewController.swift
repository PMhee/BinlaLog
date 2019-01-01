//
//  TPatientNotificationViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 14/2/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class TPatientNotificationViewController: UIViewController {
    var index = 0
    var isLoading = false
    var staticpatient = [PatientUser]()
    @IBOutlet weak var tableView: UITableView!
    var viewModel = ViewModel(){
        didSet{
            //self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(doSearchPatient), name: .textChange, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadTop {
            
            }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show"{
            if let nav = segue.destination as? UINavigationController{
                if let des = nav.topViewController as? PatientViewController{
                    des.isTeacher = true
                    des.patientcareid = self.viewModel.patientUser[self.index].patient?.id ?? ""
                }
            }
        }
    }
}
extension TPatientNotificationViewController{
    struct ViewModel {
        var patientUser = [PatientUser]()
    }
    struct PatientUser {
        var patient : PatientCare?
        var user : Person?
    }
    func joinPatientUser(patients:Results<PatientCare>){
        self.viewModel.patientUser = []
        for i in 0..<patients.count{
            let patient = patients[i]
            if let user = BackUser.getInstance().getPerson(id: patient.lbuserid){
                var pcus = PatientUser()
                pcus.patient = patient
                pcus.user = user
                self.viewModel.patientUser.append(pcus)
            }
        }
        self.staticpatient = self.viewModel.patientUser
        self.tableView.reloadData()
    }
    @objc func doSearchPatient(notification:Notification){
        self.viewModel.patientUser = self.staticpatient
        if let key = notification.userInfo?["text"] as? String{
            if !key.isEmpty{
                self.viewModel.patientUser = self.viewModel.patientUser.filter {
                    var logic = false
                    if let user = $0.user{
                        logic = user.firstname.lowercased().contains(key.lowercased()) || user.lastname.lowercased().contains(key.lowercased()) || user.studentid.lowercased().contains(key.lowercased())
                        if logic{
                            return logic
                        }
                    }else{
                        return logic
                    }
                    return logic
                }
            }
        }
        self.tableView.reloadData()
    }
}
extension TPatientNotificationViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.patientUser.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notfound", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let img_profile = cell.viewWithTag(1) as! UIImageView
            let lb_profile = cell.viewWithTag(2) as! UILabel
            let lb_date = cell.viewWithTag(3) as! UILabel
            let lb_diagnosis = cell.viewWithTag(4) as! UILabel
            let lb_verification = cell.viewWithTag(5) as! UILabel
            if let user = self.viewModel.patientUser[indexPath.row].user{
                lb_profile.text = user.firstname + " " + user.lastname + " " + user.studentid
                Helper.loadServerImage(link: user.picurl, success: {(image) in
                    img_profile.image = image
                })
            }
            img_profile.layer.cornerRadius = 20
            img_profile.layer.borderWidth = 1
            img_profile.layer.borderColor = UIColor(netHex: 0xeeeeee).cgColor
            img_profile.layer.masksToBounds = true
            if let logbook = self.viewModel.patientUser[indexPath.row].patient{
                switch logbook.verificationstatus{
                case 0 :
                    lb_verification.text = "Pending"
                    lb_verification.textColor = UIColor.lightGray
                case 1 :
                    lb_verification.text = "Accepted"
                    lb_verification.textColor = UIColor(netHex:0x63D79F)
                case 2 :
                    lb_verification.text = "Accepted"
                    lb_verification.textColor = UIColor(netHex:0x63D79F)
                case -1:
                    lb_verification.text = "Rejected"
                    lb_verification.textColor = UIColor(netHex:0xD93829)
                default:
                    lb_verification.text = "Pending"
                    lb_verification.textColor = UIColor.lightGray
                }
            }
            lb_date.text = Date().recent(from: (self.viewModel.patientUser[indexPath.row].patient?.verifytime)!)
            var diag = [String]()
            if let diagnosis = self.viewModel.patientUser[indexPath.row].patient?.diagnosis{
                for i in 0..<diagnosis.count{
                    if let diagnose = BackPatient.getInstance().getDiagnosis(id: diagnosis[i].diagnosisid){
                        diag.append(diagnose.name)
                    }
                }
            }
            lb_diagnosis.text = ""
            for i in 0..<diag.count{
                if i == diag.count-1{
                    lb_diagnosis.text = lb_diagnosis.text! + diag[i]
                }else{
                    lb_diagnosis.text = lb_diagnosis.text! + diag[i] + "\n"
                }
            }
            img_profile.layer.cornerRadius = 2
            img_profile.layer.masksToBounds = true
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.patientUser.count == 0{
            return 1
        }else{
            return self.viewModel.patientUser.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.viewModel.patientUser.count > 0 {
            self.index = indexPath.row
            self.performSegue(withIdentifier: "show", sender: self)
        }
    }
}
extension TPatientNotificationViewController:NViewControllerDelegate{
    func loadBottom(success: @escaping () -> Void) {
        if self.viewModel.patientUser.count >= 100{
            BackNotification.getInstance().enumBeforeNotification {
                self.joinPatientUser(patients: BackRotation.getInstance().listPatientCare())
                self.isLoading = false
                success()
            }
            self.joinPatientUser(patients: BackRotation.getInstance().listPatientCare())
        }else{
            self.isLoading = false
            success()
        }
    }
    func loadTop(success:@escaping () -> Void){
        BackNotification.getInstance().enumNotification {
            self.joinPatientUser(patients: BackRotation.getInstance().listPatientCare())
            self.isLoading = false
            success()
        }
        self.joinPatientUser(patients: BackRotation.getInstance().listPatientCare())
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isAtTop && !self.isLoading{
            self.isLoading = true
            self.tableView.tableHeaderView = Helper.getSpinner(sender: self.tableView)
            self.loadTop {
                self.tableView.tableHeaderView = nil
            }
        }else if scrollView.isAtBottom && !self.isLoading{
            self.isLoading = true
            self.tableView.tableFooterView = Helper.getSpinner(sender: self.tableView)
            self.loadBottom {
                self.tableView.tableFooterView = nil
            }
        }
    }
}

