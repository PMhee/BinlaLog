//
//  FilterViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 17/1/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
class FilterViewController: UIViewController {

    
    @IBOutlet weak var const_table_rotation: NSLayoutConstraint!
    @IBOutlet weak var tableViewRotation: UITableView!
    
    @IBOutlet weak var const_table_verification: NSLayoutConstraint!
    @IBOutlet weak var tableViewVerification: UITableView!
    
    @IBAction func btn_done_action(_ sender: UIBarButtonItem) {
        BackUser.getInstance().putFilter(viewModel: self.viewModel)
        self.dismiss(animated: true, completion: nil)
    }
    var viewModel = ViewModel(verify:["All","Pending","Accepted","Rejected"]){
        didSet{
            self.tableViewRotation.reload()
            self.tableViewRotation.layoutIfNeeded()
            self.const_table_rotation.constant = self.tableViewRotation.contentSize.height
            self.tableViewVerification.reload()
            self.tableViewVerification.layoutIfNeeded()
            self.const_table_verification.constant = self.tableViewVerification.contentSize.height
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initRotation()
        self.initVerification()
        // Do any additional setup after loading the view.
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
extension FilterViewController{
    struct ViewModel {
        var listRotation : Results<Rotation>?
        var verificationStatus : [String] = [String]()
        var selectRotation : Int = 0
        var selectVerifiaction : Int = 0
    }
    func initRotation(){
        self.viewModel.listRotation = BackRotation.getInstance().listMyRotation()
        if self.viewModel.listRotation != nil{
            for i in 0..<self.viewModel.listRotation!.count{
                if BackUser.getInstance().get()!.currentSelectRotation == self.viewModel.listRotation![i].id{
                    self.viewModel.selectRotation = i
                    break
                }
            }
        }
    }
    func initVerification(){
        self.viewModel.selectVerifiaction = BackUser.getInstance().get()!.currentSelectVerification
    }
}
extension FilterViewController.ViewModel{
    init(verify:[String]){
        self.verificationStatus = verify
    }
}
extension FilterViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            let lb_rotation = cell.viewWithTag(1) as! UILabel
            let lb_tick = cell.viewWithTag(2) as! UILabel
            lb_rotation.text = self.viewModel.listRotation![indexPath.row].rotationname
            lb_tick.textColor = Constant().getColorMain()
            if indexPath.row == self.viewModel.selectRotation{
                lb_tick.isHidden = false
            }else{
                lb_tick.isHidden = true
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.selectionStyle = .none
            let lb_veify = cell.viewWithTag(1) as! UILabel
            let lb_tick = cell.viewWithTag(2) as! UILabel
            lb_veify.text = self.viewModel.verificationStatus[indexPath.row]
            lb_tick.textColor = Constant().getColorMain()
            if indexPath.row == self.viewModel.selectVerifiaction{
                lb_tick.isHidden = false
            }else{
                lb_tick.isHidden = true
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1{
            if self.viewModel.listRotation != nil{
                return self.viewModel.listRotation!.count
            }else{
                return 0
            }
        }else{
            return self.viewModel.verificationStatus.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1{
            self.viewModel.selectRotation = indexPath.row
        }else{
            self.viewModel.selectVerifiaction = indexPath.row
        }
    }
}
