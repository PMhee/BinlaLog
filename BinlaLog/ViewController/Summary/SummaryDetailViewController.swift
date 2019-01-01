//
//  SummaryDetailViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 23/1/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class SummaryDetailViewController: UIViewController {
    //Routing
    var dict = [String:Int]()
    var header : String = ""
    var rotationid : String = ""
    var isEnableEditing : Bool = true
    //Variable
    var index = 0
    @IBOutlet weak var tableView: UITableView!
    var viewModel = ViewModel(){
        didSet{
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.dict = self.dict.sortedByValue
        self.title = self.header
    }

}
extension SummaryDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.dict.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notfound", for: indexPath)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let lb_title = cell.viewWithTag(1) as! UILabel
            let lb_answer = cell.viewWithTag(2) as! UILabel
            let vw_level = cell.viewWithTag(3)
            lb_title.text = self.viewModel.dict[indexPath.row].0
            lb_answer.text = String(self.viewModel.dict[indexPath.row].1)
            lb_answer.layer.cornerRadius = 3
            lb_answer.layer.masksToBounds = true
            if let procedure = BackProcedure.getInstance().get(key: self.viewModel.dict[indexPath.row].0).first{
                vw_level?.isHidden = false
                switch procedure.proctype{
                case 1:vw_level?.backgroundColor = Constant().getLvEasy()
                case 2:vw_level?.backgroundColor = Constant().getLvMedium()
                case 3:vw_level?.backgroundColor = Constant().getLvHard()
                default:print()
                }
            }else{
                vw_level?.isHidden = true
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.dict.count == 0{
            return 1
        }else{
            return self.viewModel.dict.count
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
        self.index = indexPath.row
        if self.header == "Done"{
            self.performSegue(withIdentifier: "procedure", sender: self)
        }else{
            self.performSegue(withIdentifier: "patient", sender: self)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "procedure"{
            if let des = segue.destination as? SummaryProcedureViewController{
                des.rotationid = self.rotationid
                if let procedure = BackProcedure.getInstance().get(key: self.viewModel.dict[self.index].0).first{
                    des.procedureid = procedure.id
                    des.isEnableEditing = self.isEnableEditing
                }
            }
        }else if segue.identifier == "patient"{
            if let des = segue.destination as? SummaryPatientViewController{
                des.rotationid = self.rotationid
                if let symptom = BackPatient.getInstance().getSymptom(key: self.viewModel.dict[self.index].0){
                    des.symptomid = symptom.id
                }
                if let diagnosis = BackPatient.getInstance().getDiagnosis(key: self.viewModel.dict[self.index].0){
                    des.diagnosisid = diagnosis.id
                }
                if let disease = BackPatient.getInstance().getDisease(key: self.viewModel.dict[self.index].0){
                    des.diseaseid = disease.id
                }
            }
        }
    }
}
extension SummaryDetailViewController{
    struct ViewModel {
        var dict = [(String,Int)]()
    }
}
