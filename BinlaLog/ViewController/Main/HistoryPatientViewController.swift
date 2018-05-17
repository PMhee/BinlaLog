//
//  HistoryPatientViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/5/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class HistoryPatientViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    var index = 0
    var isLoading = false
    var staticPatient = [PatientCare]()
    @IBOutlet weak var tableView: UITableView!
    var viewModel = ViewModel(){
        didSet{
        }
    }
    func initViewModele(){
        if let user = BackUser.getInstance().get(){
            self.viewModel.selectedRotation = user.currentSelectRotation
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(doSearchPatient), name: .textChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isDelete), name: .isDelete, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initViewModele()
        self.initPatientCare()
        self.loadTop {}
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if self.viewModel.patientcare.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "notfound", for: indexPath)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                let lb_patient_name = cell.viewWithTag(2) as! UILabel
                let lb_date = cell.viewWithTag(3) as! UILabel
                lb_patient_name.text = self.viewModel.patientcare[indexPath.row].name.uppercased() + " " + self.viewModel.patientcare[indexPath.row].HN
                lb_date.text = Date().recent(from: self.viewModel.patientcare[indexPath.row].updatetime)
                let lb_verification = cell.viewWithTag(5) as! UILabel
                let lb_diagnosis = cell.viewWithTag(6) as! UILabel
                let vw_message = cell.viewWithTag(7)
                vw_message?.isHidden = true
                vw_message?.layer.cornerRadius = 3
                vw_message?.layer.masksToBounds = true
                if self.viewModel.patientcare[indexPath.row].verifymessage != ""{
                    vw_message?.isHidden = false
                }
                var diag = [String]()
                for i in 0..<self.viewModel.patientcare[indexPath.row].diagnosis.count{
                    if let diagnosis = BackPatient.getInstance().getDiagnosis(id: self.viewModel.patientcare[indexPath.row].diagnosis[i].diagnosisid){
                        diag.append(diagnosis.name)
                    }
                }
                lb_diagnosis.text = ""
                for i in 0..<diag.count{
                    if i == diag.count-1{
                        lb_diagnosis.text = lb_diagnosis.text! + "#"+diag[i]
                    }else{
                        lb_diagnosis.text = lb_diagnosis.text! + "#"+diag[i] + "\n"
                    }
                }
                switch self.viewModel.patientcare[indexPath.row].verificationstatus{
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
                return cell
            }
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Helper.showLoading(sender: self)
            BackRotation.getInstance().deletePatient(patientid: self.viewModel.patientcare[indexPath.row].id, finish: {
                self.dismiss(animated: false, completion: nil)
                self.viewModel.patientcare.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.index = indexPath.row
        if self.viewModel.patientcare.count > 0{
            self.performSegue(withIdentifier: "edit", sender: self)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.patientcare.count == 0 {
            return 0
        }else{
            return self.viewModel.patientcare.count
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"{
            if let navigation = segue.destination as? UINavigationController{
                if let des = navigation.topViewController as? PatientViewController{
                    des.patientcareid = self.viewModel.patientcare[self.index].id
                    des.rotationid = self.viewModel.patientcare[self.index].rotationid
                }
            }
        }
    }
}
extension HistoryPatientViewController{
    struct ViewModel {
        var patientcare = [PatientCare]()
        var selectedRotation : String!
    }
    @objc func isDelete(notification:Notification){
        self.tableView.isEditing = !self.tableView.isEditing
    }
    @objc func doSearchPatient(notification:Notification){
        if let key = notification.userInfo?["text"] as? String{
            self.viewModel.patientcare = self.staticPatient
            if !key.isEmpty{
                self.viewModel.patientcare = self.viewModel.patientcare.filter({
                    return $0.name.lowercased().contains(key.lowercased()) || $0.HN.lowercased().contains(key.lowercased())
                })
            }
            self.tableView.reloadData()
        }
    }
    func initPatientCare(){
        self.viewModel.patientcare = []
        let temp = BackRotation.getInstance().listPatientCare(rotationid: BackUser.getInstance().get()!.currentSelectRotation)
        for i in 0..<temp.count{
            self.viewModel.patientcare.append(temp[i])
        }
        self.staticPatient = self.viewModel.patientcare
        self.tableView.reloadData()
    }
    
}
extension HistoryPatientViewController:NViewControllerDelegate{
    func loadBottom(success: @escaping () -> Void) {
        success()
    }
    func loadTop(success:@escaping () -> Void){
        self.isLoading = true
        BackRotation.getInstance().EnumPatientCare(updatetime: BackRotation.getInstance().getLastUpdateTime(rotationid:BackUser.getInstance().get()!.currentSelectRotation),rotationid: self.viewModel.selectedRotation, finish: {
            self.initPatientCare()
            self.isLoading = false
            success()
        })
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        Helper.tableViewLoading(sender: self, tableView: self.tableView, offset: scrollView.contentOffset.y, isLoading: self.isLoading)
    }
}
extension HistoryPatientViewController.ViewModel{
    init(patientcare:[PatientCare],selectedRotation:String="") {
        self.patientcare = patientcare
        self.selectedRotation = selectedRotation
    }
}
