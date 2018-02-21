//
//  SummaryPatientViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 29/1/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class SummaryPatientViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    //Routing
    var rotationid: String = ""
    var symptomid : String = ""
    var diagnosisid : String = ""
    var diseaseid : String = ""
    //Variable
    var index = 0
    var viewModel = ViewModel(){
        didSet{
            self.tableView.reload()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initPatientCare()
    }
}
extension SummaryPatientViewController{
    struct ViewModel {
        var patientcare : Results<PatientCare>?
    }
    func initPatientCare(){
        self.viewModel.patientcare = BackRotation.getInstance().listPatientCare(rotationid: self.rotationid, symptomid: self.symptomid, diseaseid: self.diseaseid, diagnosisid: self.diagnosisid)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"{
            if let nav = segue.destination as? UINavigationController{
                if let des = nav.topViewController as? PatientViewController{
                    des.rotationid = self.rotationid
                    des.patientcareid = self.viewModel.patientcare![self.index].id
                }
            }
        }
    }
}
extension SummaryPatientViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lb_patient_name = cell.viewWithTag(2) as! UILabel
        let lb_date = cell.viewWithTag(3) as! UILabel
        lb_patient_name.text = self.viewModel.patientcare![indexPath.row].name.uppercased() + " " + self.viewModel.patientcare![indexPath.row].HN
        lb_date.text = Date().recent(from: self.viewModel.patientcare![indexPath.row].updatetime)
        let lb_verification = cell.viewWithTag(5) as! UILabel
        let lb_diagnosis = cell.viewWithTag(6) as! UILabel
        var diag = [String]()
        for i in 0..<self.viewModel.patientcare![indexPath.row].diagnosis.count{
            if let diagnosis = BackPatient.getInstance().getDiagnosis(id: self.viewModel.patientcare![indexPath.row].diagnosis[i].diagnosisid){
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
        switch self.viewModel.patientcare![indexPath.row].verificationstatus{
        case 0 :
            lb_verification.text = "Pending"
            lb_verification.textColor = UIColor.lightGray
        case 1 :
            lb_verification.text = "Accepted"
            lb_verification.textColor = UIColor(netHex:0x63D79F)
        case 2:
            lb_verification.text = "Rejected"
            lb_verification.textColor = UIColor(netHex:0xD93829)
        default:
            lb_verification.text = "Pending"
            lb_verification.textColor = UIColor.lightGray
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.index = indexPath.row
        if self.viewModel.patientcare != nil{
            if self.viewModel.patientcare!.count > 0{
                self.performSegue(withIdentifier: "edit", sender: self)
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.patientcare == nil{
            return 0
        }else{
            return self.viewModel.patientcare!.count
        }
    }
}
