//
//  PatientViewController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/5/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import UIKit
import MapKit
class PatientViewController: UIViewController,UITextFieldDelegate,TagListViewDelegate {
    //GI not need disease
    @IBOutlet weak var const_top_disease: NSLayoutConstraint!
    @IBOutlet weak var vw_disease_icon: UIView!
    
    //Handle APP
    func handleApp(){
        #if GILOG
            self.tf_hn.keyboardType = .numberPad
            self.tf_symptom.type = 1
            self.tf_diagnosis.type = 2
            self.tf_symptom.sender = self
            self.tf_diagnosis.sender = self
            self.tf_disease.isHidden = true
            self.vw_disease_tag.isHidden = true
            self.vw_disease_icon.isHidden = true
            self.const_top_disease.constant = -47
        #endif
    }
    //Route
    var patientcareid : String = ""
    var rotationid : String = ""
    var selectedDateType = 0
    // 4  == start date
    // 5  == enddate
    //now keyboard is vv_coursedetail
    var isTeacher = false
    @IBOutlet weak var tf_passcode: UITextField!
    @IBOutlet weak var segment_type: UISegmentedControl!
    @IBOutlet weak var lb_course: UILabel!
    @IBOutlet weak var lb_deadline: UILabel!
    @IBOutlet weak var tf_hn: NTextField!
    @IBOutlet weak var tf_name: NTextField!
    @IBOutlet weak var tf_symptom: NAutoComplete!
    @IBOutlet weak var vw_symptom_tag: TagListView!
    @IBOutlet weak var tf_diagnosis: NAutoComplete!
    @IBOutlet weak var tf_disease: NAutoComplete!
    @IBOutlet weak var vw_diagnosis_tag: TagListView!
    @IBOutlet weak var cons_height_symptom_tag: NSLayoutConstraint!
    @IBOutlet weak var cons_height_diagnosis_tag: NSLayoutConstraint!
    @IBOutlet weak var cons_height_disease_tag: NSLayoutConstraint!
    @IBOutlet weak var vw_disease_tag: TagListView!
    @IBOutlet weak var tf_startdate: NTextField!
    @IBOutlet weak var tf_enddate: NTextField!
    @IBOutlet var map: MKMapView!
    @IBOutlet weak var vw_signature: NViewCard!
    @IBOutlet weak var lb_message: NLabel!
    @IBOutlet weak var img_teacher_profile: UIImageView!
    @IBOutlet weak var lb_teacher_name: UILabel!
    @IBOutlet weak var lb_verification_date: UILabel!
    @IBOutlet weak var cons_bottom: NSLayoutConstraint!
    @IBOutlet weak var const_teacher_feedback_bottom: NSLayoutConstraint!
    @IBOutlet weak var cons_image_bottom: NSLayoutConstraint!
    @IBAction func btn_cancel_action(_ sender: UIBarButtonItem) {
        self.doClose()
    }
    @IBOutlet weak var vw_message: NViewCard!
    @IBOutlet weak var tv_note: UITextView!
    @IBOutlet weak var lb_placeholder_note: UILabel!
    
    @IBAction func btn_message_action(_ sender: UIButton) {
        self.performSegue(withIdentifier: "feedback", sender: self)
    }
    
    @IBAction func btn_save_action(_ sender: UIBarButtonItem) {
        if Date() > self.viewModel.deadline {
            Helper.addAlert(sender: self, title: "", message: "The rotation has been end")
        }else if self.viewModel.latitude == 0.0 && self.viewModel.longitude == 0.0{
            Helper.addAlert(sender: self, title: "", message: "Please turn location in Settings>Privacy>Location Services on")
        }else if self.viewModel.hn.isEmpty{
            Helper.addAlert(sender: self, title: "", message: "Please fill patient HN")
        }else if self.viewModel.name.isEmpty{
            Helper.addAlert(sender: self, title: "", message: "Please fill patient Name")
        }else if self.viewModel.startdate > self.viewModel.enddate{
            Helper.addAlert(sender: self, title: "", message: "Start time cannot be late than endtime")
        }else if self.viewModel.enddate > self.viewModel.deadline{
            Helper.addAlert(sender: self, title: "", message: "Cannot add patient that enddate beyond deadline")
        }else if self.viewModel.startdate < self.viewModel.rotationstarttime{
            Helper.addAlert(sender: self, title: "", message: "Cannot add patient that startime earlier that rotation starttime")
        } else{
            Helper.showLoading(sender: self)
            BackRotation.getInstance().updatePatientCare(viewModel: self.viewModel, finish: {
                self.dismiss(animated: false, completion: nil)
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    @IBAction func tf_symptom_change(_ sender: NTextField) {
        guard let key = sender.text else{
            return
        }
        self.doSearchSymptom(key: key)
    }
    @IBAction func tf_symptom_end(_ sender: NAutoComplete) {
        guard let key = sender.text else {
            return
        }
        if !self.tf_symptom.isClickInfo{
            self.addSymptom(key: key)
        }
        sender.text = ""
    }
    @IBAction func tf_diagnosis_change(_ sender: NAutoComplete) {
        guard let key = sender.text else {
            return
        }
        self.doSearchDiagnosis(key: key)
        //self.searchServerDiagnosis(key: key)
    }
    @IBAction func tf_diagnosis_end(_ sender: NAutoComplete) {
        guard let key = sender.text else {
            return
        }
        if !self.tf_diagnosis.isClickInfo{
            self.addDiagnosis(key: key)
        }
        sender.text = ""
    }
    @IBAction func tf_disease_change(_ sender: NAutoComplete) {
        guard let key = sender.text else {
            return
        }
        self.doSearchDisease(key: key)
    }
    @IBAction func tf_disease_end(_ sender: NAutoComplete) {
        guard let key = sender.text else {
            return
        }
        if !self.tf_disease.isClickInfo{
            self.addDisease(key: key)
        }
        sender.text = ""
    }
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if sender.tag == 1{
            self.deleteSymptom(key: title)
        }else if sender.tag == 2{
            self.deleteDiagnosis(key: title)
        }else if sender.tag == 3{
            self.deleteDisease(key: title)
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 4 || textField.tag == 5{
            self.selectedDateType = textField.tag
            if textField.tag == 4{
                Helper.showDatePicker(sender: self,date:self.viewModel.startdate, restrictDate: self.viewModel.deadline)
            }else{
                Helper.showDatePicker(sender: self,date:self.viewModel.enddate, restrictDate: self.viewModel.deadline)
            }
            return false
        }else{
            return true
        }
        
    }
    func setUI(){
        if self.isTeacher{
            self.tf_hn.isEnabled = false
            self.tf_name.isEnabled = false
            self.segment_type.isEnabled = false
            self.tf_symptom.isEnabled = false
            self.vw_symptom_tag.isUserInteractionEnabled = false
            self.tf_diagnosis.isEnabled = false
            self.vw_diagnosis_tag.isUserInteractionEnabled = false
            self.tf_disease.isEnabled = false
            self.vw_disease_tag.isUserInteractionEnabled = false
            self.tf_startdate.isEnabled = false
            self.tf_enddate.isEnabled = false
            self.tf_passcode.isEnabled = false
            self.tv_note.isEditable = false
            self.tf_hn.textColor = .lightGray
            self.tf_name.textColor = .lightGray
            self.segment_type.tintColor = .lightGray
            self.tf_symptom.textColor = .lightGray
            self.tf_diagnosis.textColor = .lightGray
            self.tf_disease.textColor = .lightGray
            self.tf_startdate.textColor = .lightGray
            self.tf_enddate.textColor = .lightGray
            self.tf_passcode.textColor = .lightGray
            self.tv_note.textColor = .lightGray
            self.navigationItem.setRightBarButton(nil, animated: false)
        }else{
            self.vw_message.isHidden = true
        }
        self.lb_message.layer.cornerRadius = 16
        self.lb_message.layer.masksToBounds = true
        self.tf_hn.makeBottomTextfield()
        self.tf_name.makeBottomTextfield()
        self.tf_startdate.makeBottomTextfield()
        self.tf_enddate.makeBottomTextfield()
        self.segment_type.tintColor = Constant().getColorMain()
        self.vw_message.backgroundColor = Constant().getColorMain()
        self.vw_message.layer.cornerRadius = 30
        self.vw_message.layer.masksToBounds = true
        self.tv_note.layer.borderWidth = 1
        self.tv_note.layer.borderColor = UIColor(netHex:0xeeeeee).cgColor
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(dateChange), name: .dateChange, object: nil)
    }
    @objc func dateChange(notification:Notification){
        if let date = notification.userInfo?["date"] as? Date{
            if self.selectedDateType == 4{
                self.viewModel.startdate = date
            }else{
                self.viewModel.enddate = date
            }
            
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
    
    
    
    //Binding ViewModel
    @IBAction func tf_name_change(_ sender: NTextField) {
        self.limitTextfieldSize(textField: sender, maxSize: 2)
        guard let text = sender.text else {
            return
        }
        self.viewModel.name = text
    }
    @IBAction func tf_passcode_change(_ sender: UITextField) {
        self.limitTextfieldSize(textField: sender, maxSize: 6)
        guard let text = sender.text else {
            return
        }
        self.viewModel.verification = text
    }
    @IBAction func tf_hn_change(_ sender: NTextField) {
        guard let text = sender.text else {
            return
        }
        self.viewModel.hn = text
    }
    @IBAction func sg_change(_ sender: UISegmentedControl) {
        self.viewModel.type = sender.selectedSegmentIndex
    }
    var viewModel = ViewModel(){
        didSet{
            self.lb_course.watch(subject: viewModel.course)
            self.lb_deadline.watch(subject: (viewModel.deadline?.convertToString())!)
            self.tf_name.watch(subject: viewModel.name)
            self.tf_hn.watch(subject: viewModel.hn)
            self.segment_type.watch(subject: viewModel.type)
            self.tf_startdate.watch(subject: viewModel.startdate.convertToStringOnlyDate())
            self.tf_enddate.watch(subject: viewModel.enddate.convertToStringOnlyDate())
            self.tf_passcode.watch(subject: viewModel.verification)
            self.vw_symptom_tag.removeAllTags()
            for i in 0..<viewModel.symptom.count{
                self.vw_symptom_tag.addTag(viewModel.symptom[i])
            }
            self.vw_diagnosis_tag.removeAllTags()
            for i in 0..<viewModel.diagnosis.count{
                self.vw_diagnosis_tag.addTag(viewModel.diagnosis[i])
            }
            self.vw_disease_tag.removeAllTags()
            for i in 0..<viewModel.disease.count{
                self.vw_disease_tag.addTag(viewModel.disease[i])
            }
            if let verification = BackVerification.getInstance().get(id: self.viewModel.verificationid){
                if let teacher = BackUser.getInstance().getPerson(id: verification.lbuserid){
                    Helper.loadLocalImage(id: teacher.id, success: {(image) in
                        self.img_teacher_profile.image = image
                    })
                    self.lb_teacher_name.watch(subject: teacher.firstname+" "+teacher.lastname)
                }
            }
            self.lb_message.watch(subject: self.viewModel.message)
            self.lb_verification_date.watch(subject: self.viewModel.verifydate?.convertToStringOnlyDate() ?? "")
            if self.viewModel.note.isEmpty{
                self.lb_placeholder_note.isHidden = false
            }else{
                self.lb_placeholder_note.isHidden = true
            }
            self.tv_note.text = self.viewModel.note
            self.addTeacherComment()
        }
    }
    func initPatientCare(){
        var patientcare = PatientCare()
        if BackRotation.getInstance().getPatientCare(id: self.patientcareid) != nil{
            patientcare = BackRotation.getInstance().getPatientCare(id: self.patientcareid)!
        }
        self.viewModel = ViewModel(passcode: "", type: 0, patientcare: patientcare,rotationid:rotationid)
        for i in 0..<patientcare.diagnosis.count{
            if let content = BackPatient.getInstance().getDiagnosis(id: patientcare.diagnosis[i].diagnosisid){
                self.viewModel.diagnosis.append(content.name)
                self.updateDiagnosisConstrain()
            }
        }
        for i in 0..<patientcare.disease.count{
            if let content = BackPatient.getInstance().getDisease(id: patientcare.disease[i].diseaseid){
                self.viewModel.disease.append(content.name)
                self.updateDiseaseConstrain()
            }
        }
        for i in 0..<patientcare.symptom.count{
            if let content = BackPatient.getInstance().getSymptom(id: patientcare.symptom[i].symptomid){
                self.viewModel.symptom.append(content.name)
                self.updateSymptomConstrain()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPatientCare()
        self.setUI()
        self.loadSymptom()
        self.loadDisease()
        self.loadDiagnosis()
        self.initSymptomAutoCompleteUI()
        self.initDiagnosisAutoCompleteUI()
        self.initDiseaseAutoCompleteUI()
        self.initMap()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addObserver()
        self.handleApp()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addTeacherComment()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "feedback"{
            if let des = segue.destination as? CommentViewController{
                des.isPatient = true
                des.viewModelPatient = self.viewModel
            }
        }
    }
}
extension PatientViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.viewModel.note = textView.text
    }
}

