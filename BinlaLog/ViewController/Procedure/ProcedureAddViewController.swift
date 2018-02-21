//
//  ProcedureAddViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/12/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit
import MapKit
class ProcedureAddViewController: UIViewController,UITextFieldDelegate {

    //Routing Data
    var procedureid : String = ""
    var rotationid : String = ""
    var logbookid : String = ""
    //Varaible
    var isEnableEditing = true
    var isTeacher = false
    @IBOutlet var map: MKMapView!
    @IBOutlet weak var lb_rotation_name: UILabel!
    @IBOutlet weak var lb_rotation_deadline: UILabel!
    @IBOutlet weak var tf_hn: NTextField!
    @IBOutlet weak var sg_proctype: UISegmentedControl!
    @IBOutlet weak var sg_patient_type: UISegmentedControl!
    @IBOutlet weak var vw_message: NViewCard!
    
    @IBOutlet weak var btn_info: UIButton!
    @IBOutlet weak var tf_procedure: NAutoComplete!
    @IBOutlet weak var img_feel_1: UIButton!
    @IBOutlet weak var img_feel_2: UIButton!
    @IBOutlet weak var img_feel_3: UIButton!
    @IBOutlet weak var img_feel_4: UIButton!
    @IBOutlet weak var img_feel_5: UIButton!
    @IBOutlet weak var tf_date: NTextField!
    @IBOutlet weak var tf_passcode: UITextField!
    @IBOutlet weak var vw_signature: NViewCard!
    @IBOutlet weak var lb_message: NLabel!
    @IBOutlet weak var img_teacher_profile: UIImageView!
    @IBOutlet weak var lb_teacher_name: UILabel!
    @IBOutlet weak var lb_verification_date: UILabel!
    @IBOutlet weak var cons_bottom: NSLayoutConstraint!
    @IBOutlet weak var const_teacher_feedback_bottom: NSLayoutConstraint!
    @IBOutlet weak var cons_image_bottom: NSLayoutConstraint!
    @IBOutlet weak var tv_note: UITextView!
    @IBOutlet weak var lb_note_placeholder: UILabel!
    
    @IBAction func btn_message_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "feedback", sender: self)
    }
    @IBAction func btn_procedure_information(_ sender: UIButton) {
        self.performSegue(withIdentifier: "info", sender: self)
    }
    @IBAction func btn_done_action(_ sender: UIBarButtonItem) {
        if Date() > self.viewModel.rotationdeadline{
            Helper.addAlert(sender: self, title: "", message: "The rotation has been end")
        }else if self.viewModel.procedureName.isEmpty{
            Helper.addAlert(sender: self, title: "", message: "Please fill procedure")
        }else if self.viewModel.latitude == 0.0 && self.viewModel.longitude == 0.0{
            Helper.addAlert(sender: self, title: "", message: "Please turn location in Settings>Privacy>Location Services on")
        }else if self.viewModel.feeling == -1{
            Helper.addAlert(sender: self, title: "", message: "Please select feeling")
        }else if self.viewModel.hn.isEmpty{
            Helper.addAlert(sender: self, title: "", message: "Please fill patient HN")
        }else if self.viewModel.date > self.viewModel.rotationdeadline{
            Helper.addAlert(sender: self, title: "", message: "Cannot add logbook that date beyond rotation deadline")
        }else if self.viewModel.date < self.viewModel.rotationstarttime{
            Helper.addAlert(sender: self, title: "", message: "Cannot add logbook that date earlier than rotation starttime")
        }else {
            Helper.showLoading(sender: self)
            BackRotation.getInstance().updateLogbook(viewModel: self.viewModel, finish: {
                self.dismiss(animated: false, completion: nil)
                self.dismiss(animated: true, completion: nil)
            }, error: {
                self.dismiss(animated: false, completion: nil)
                Helper.showWarning(sender: self, text: "Internet connection error")
            })
        }
    }
    @IBAction func btn_cancel_action(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sg_proctype_change(_ sender: UISegmentedControl) {
        self.viewModel.logtype = sender.selectedSegmentIndex
    }
    @IBAction func sg_patient_type_change(_ sender: UISegmentedControl) {
        self.viewModel.patientType = sender.selectedSegmentIndex
    }
    @IBAction func tf_procedure_change(_ sender: NAutoComplete) {
        
    }
    
    @IBAction func tf_hn_change(_ sender: NTextField) {
        guard let text = sender.text else {
            return
        }
        self.viewModel.hn = text
    }
    @IBAction func img_feel_1_action(_ sender: UIButton) {
        self.viewModel.feeling = 0
    }
    @IBAction func img_feel_2_action(_ sender: UIButton) {
        self.viewModel.feeling = 1
    }
    @IBAction func img_feel_3_action(_ sender: UIButton) {
        self.viewModel.feeling = 2
    }
    @IBAction func img_feel_4_action(_ sender: UIButton) {
        self.viewModel.feeling = 3
    }
    @IBAction func img_feel_5_action(_ sender: UIButton) {
        self.viewModel.feeling = 4
    }
    @IBAction func tf_passcode_change(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        if self.limitTextfieldSize(textField: sender, maxSize: 6){
            self.viewModel.verification = text
        }
        
        
    }
    @IBAction func tf_procedure_end(_ sender: NAutoComplete) {
        guard let text = sender.text else {
            return
        }
        self.validateProcedure(text: text)
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1{
            Helper.showDatePicker(sender: self, date: self.viewModel.date, restrictDate: self.viewModel.rotationdeadline)
            return false
        }else{
            return true
        }
        
    }
    var viewModel = ViewModel(){
        didSet{
            self.lb_rotation_name.watch(subject: self.viewModel.rotationname)
            self.lb_rotation_deadline.watch(subject: self.viewModel.rotationdeadline.addingTimeInterval(-1).convertToString())
            self.tf_procedure.watch(subject: self.viewModel.procedureName)
            self.tf_date.watch(subject: self.viewModel.date.convertToStringOnlyDate())
            self.changeFeeling()
            self.sg_proctype.watch(subject: self.viewModel.logtype)
            self.sg_patient_type.watch(subject: self.viewModel.patientType)
            self.tf_hn.watch(subject: self.viewModel.hn)
            self.tf_passcode.watch(subject: self.viewModel.verification)
            self.lb_message.watch(subject: self.viewModel.message)
            self.addTeacherComment()
            if self.viewModel.note.isEmpty{
                self.lb_note_placeholder.isHidden = false
            }else{
                self.lb_note_placeholder.isHidden = true
            }
            self.tv_note.text = self.viewModel.note
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(dateChange), name: .dateChange, object: nil)
    }
    @objc func dateChange(notification:Notification){
        if let date = notification.userInfo?["date"] as? Date{
            self.viewModel.date = date
        }
    }
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    func initMap(){
        self.map.isUserInteractionEnabled = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initLogbook()
        self.initProcedure()
        self.initRotation()
        self.initProcedureAutoCompleteUI()
        self.addObserver()
        self.initMap()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addTeacherComment()
    }
    func setUI(){
        if self.isEnableEditing{
            self.navigationItem.setLeftBarButton(nil, animated: false)
        }
        self.vw_message.backgroundColor = Constant().getColorMain()
        self.vw_message.layer.cornerRadius = 30
        self.vw_message.layer.masksToBounds = true
        if self.isTeacher{
            self.tf_hn.isEnabled = false
            self.sg_proctype.isEnabled = false
            self.sg_patient_type.isEnabled = false
            self.tf_procedure.isEnabled = false
            self.img_feel_1.isEnabled = false
            self.img_feel_2.isEnabled = false
            self.img_feel_3.isEnabled = false
            self.img_feel_4.isEnabled = false
            self.img_feel_5.isEnabled = false
            self.tf_date.isEnabled = false
            self.tf_passcode.isEnabled = false
            self.tf_hn.textColor = .lightGray
            self.sg_proctype.tintColor = .lightGray
            self.sg_patient_type.tintColor = .lightGray
            self.tf_procedure.textColor = .lightGray
            self.tf_date.textColor = .lightGray
            self.tf_passcode.textColor = .lightGray
            self.lb_rotation_deadline.textColor = .lightGray
            self.tv_note.textColor = .lightGray
            self.btn_info.isHidden = true
            self.tv_note.isEditable = false
            self.navigationItem.setRightBarButton(nil, animated: false)
        }else{
            self.vw_message.isHidden = true
        }
        self.navigationController?.isNavigationBarHidden = false
        self.map.isUserInteractionEnabled = false
        self.sg_patient_type.tintColor = Constant().getColorMain()
        self.sg_proctype.tintColor = Constant().getColorMain()
        self.img_teacher_profile.layer.cornerRadius = 2
        self.lb_message.layer.cornerRadius = 16
        self.lb_message.layer.masksToBounds = true
        self.tv_note.layer.borderWidth = 1
        self.tv_note.layer.borderColor = UIColor(netHex:0xeeeeee).cgColor
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "info"{
                if let des = segue.destination as? SummaryProcedureViewController{
                    des.rotationid = self.rotationid
                    des.procedureid = self.viewModel.procedureid
                    des.isEnableEditing = false
                }
        }else if segue.identifier == "feedback"{
            if let des = segue.destination as? CommentViewController{
                des.viewModel = self.viewModel
            }
        }
    }
}
extension ProcedureAddViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.viewModel.note = textView.text
    }
}
