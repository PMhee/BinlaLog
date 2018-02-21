//
//  HomeViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/4/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var rotationid : String = ""
    var index = 0
    func initViewModel() {
        self.viewModel = ViewModel()
    }
    @IBOutlet weak var tableView: UITableView!
    var viewModel = ViewModel(){
        didSet{
            self.tableView.reload()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewModel()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUI()
        self.getCurrentRotation()
        self.getRecentRotation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setUI(){
        UIApplication.shared.statusBarStyle = .lightContent
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.user != nil{
            if indexPath.row < self.viewModel.user!.currentRotation.count{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeCellTableViewCell
                cell.sender = self
                if let rotation = BackRotation.getInstance().get(id: self.viewModel.user!.currentRotation[indexPath.row].rotationid){
                    cell.lb_rotation_name.text = rotation.rotationname
                    if rotation.logbookendtime.offset(from: Date()) == "Just now"{
                        cell.lb_rotation_date.text = "This rotation is end"
                    }
                }
                cell.btn_add_procedure.tag = indexPath.row * 2 - 1
                cell.btn_add_patient.tag = indexPath.row * 2
                cell.selectionStyle = .none
                cell.act.isHidden = true
                return cell
            }else if indexPath.row == self.viewModel.user!.currentRotation.count{
                let cell = tableView.dequeueReusableCell(withIdentifier: "title", for: indexPath)
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "history", for: indexPath)
                let lb_rotationname = cell.viewWithTag(2) as! UILabel
                let lb_rotationdate = cell.viewWithTag(3) as! UILabel
                let lb_logbook_done_no = cell.viewWithTag(5) as! UILabel
                let lb_patient_done_no = cell.viewWithTag(7) as! UILabel
                cell.selectionStyle = .none
                if let rotation = BackRotation.getInstance().get(id: self.viewModel.user!.recentRotation[indexPath.row-1-self.viewModel.user!.currentRotation.count].rotationid){
                    lb_rotationname.text = rotation.rotationname
                    lb_rotationdate.text = rotation.endtime.convertToStringOnlyDate()
                    lb_logbook_done_no.text = String(rotation.noDone)
                    lb_patient_done_no.text = String(rotation.patientDone)
                }
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "title", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.user != nil{
            return 1+self.viewModel.user!.currentRotation.count+self.viewModel.user!.recentRotation.count
        }else{
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.viewModel.user!.currentRotation.count{
            self.rotationid = self.viewModel.user!.currentRotation[indexPath.row].rotationid
        }else{
            self.rotationid = self.viewModel.user!.recentRotation[indexPath.row-1-self.viewModel.user!.currentRotation.count].rotationid
        }
        self.performSegue(withIdentifier: "summary", sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
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
