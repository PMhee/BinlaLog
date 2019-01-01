//
//  SummaryViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 22/1/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class SummaryViewController: UIViewController {
    //Router
    var rotationid : String = ""
    var index = 0
    var table = 0
    var dict = [String:String]()
    @IBOutlet weak var lb_rotationenddate: UILabel!
    @IBOutlet weak var lb_rotation_startdate: UILabel!
    @IBOutlet weak var lb_rotation_name: UILabel!
    @IBOutlet weak var tableView_procedure: UITableView!
    @IBOutlet weak var cons_height_table_procedure: NSLayoutConstraint!
    @IBOutlet weak var tableView_symptom: UITableView!
    @IBOutlet weak var cons_height_table_symptom: NSLayoutConstraint!
    
    var viewModel = ViewModel(){
        didSet{
            if self.viewModel.rotation != nil{
                self.lb_rotation_name.watch(subject: self.viewModel.rotation!.rotationname)
                self.lb_rotation_startdate.watch(subject: self.viewModel.rotation!.starttime.convertToStringOnlyDate())
                self.lb_rotationenddate.watch(subject: self.viewModel.rotation!.endtime.convertToStringOnlyDate())
            }
            self.tableView_procedure.reloadData()
            self.tableView_procedure.layoutIfNeeded()
            self.cons_height_table_procedure.constant  =  self.tableView_procedure.contentSize.height
            self.tableView_symptom.reloadData()
            self.tableView_symptom.layoutIfNeeded()
            self.cons_height_table_symptom.constant = self.tableView_symptom.contentSize.height
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initRotation()
        self.initProcedure()
        self.initPatient()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView_procedure.reloadData()
        self.tableView_procedure.layoutIfNeeded()
        self.cons_height_table_procedure.constant  =  self.tableView_procedure.contentSize.height
        self.tableView_symptom.reloadData()
        self.tableView_symptom.layoutIfNeeded()
        self.cons_height_table_symptom.constant = self.tableView_symptom.contentSize.height
    }
}
extension SummaryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lb_title = cell.viewWithTag(1) as! UILabel
        let lb_ans = cell.viewWithTag(2) as! UILabel
        if tableView.tag == 2{
            lb_title.text = self.viewModel.patient[indexPath.row].0
            lb_ans.text = self.viewModel.patient[indexPath.row].1
        }else{
            lb_title.text = self.viewModel.procedure[indexPath.row].0
            lb_ans.text = self.viewModel.procedure[indexPath.row].1
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 2{
           return self.viewModel.patient.count
        }else{
            return self.viewModel.procedure.count
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        self.table = tableView.tag
        self.performSegue(withIdentifier: "detail", sender: self)
    }
}
extension SummaryViewController{
    struct ViewModel {
        var rotation : Rotation?
        var procedure = [(String,String)]()
        var patient = [(String,String)]()
    }
    func initRotation(){
        self.viewModel.rotation = BackRotation.getInstance().get(id: self.rotationid)
    }
    func initProcedure(){
        var procedure = [String:String]()
        procedure["\(Constant().getFirstPageTitle())"] = String(BackRotation.getInstance().summaryProcedureDone(rotationid: self.viewModel.rotation!.id).count)
        self.viewModel.procedure = procedure.sortedByKey
    }
    func initPatient(){
        var patient = [String:String]()
        patient["Diagnosis"] = String(BackRotation.getInstance().summaryDiagnosis(rotationid: self.viewModel.rotation!.id).count)
        patient["Disease"] = String(BackRotation.getInstance().summaryDisease(rotationid: self.viewModel.rotation!.id).count)
        patient["Symptom"] = String(BackRotation.getInstance().summarySymptom(rotationid: self.viewModel.rotation!.id).count)
        self.viewModel.patient = patient.sortedByKey
    }
    func initLogbook(){
        BackRotation.getInstance().EnumLogbook(updatetime: BackRotation.getInstance().getLogbookLastUpdateTime(rotationid: self.rotationid), rotationid: self.rotationid, finish: {
            self.initProcedure()
        })
    }
    func initPatientCare(){
        BackRotation.getInstance().EnumPatientCare(updatetime: BackRotation.getInstance().getLastUpdateTime(rotationid:self.rotationid),rotationid: self.rotationid, finish: {
            self.initPatient()
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail"{
            if let des = segue.destination as? SummaryDetailViewController{
                var dict = [String:Int]()
                var title = ""
                if self.table == 1{
                    switch self.index{
                    case 0:dict = BackRotation.getInstance().summaryProcedureDone(rotationid: self.viewModel.rotation!.id)
                        title = "Done"
                    default:print()
                    }
                }else{
                    switch self.index{
                    case 0:dict = BackRotation.getInstance().summaryDiagnosis(rotationid: self.viewModel.rotation!.id)
                        title = "Diagnosis"
                    case 1:dict = BackRotation.getInstance().summaryDisease(rotationid: self.viewModel.rotation!.id)
                        title = "Disease"
                    case 2:dict = BackRotation.getInstance().summarySymptom(rotationid: self.viewModel.rotation!.id)
                        title = "Symptom"
                    default:print()
                    }
                }
                des.dict = dict
                des.header = title
                des.rotationid = self.rotationid
            }
        }
    }
}
extension SummaryViewController.ViewModel{
}
