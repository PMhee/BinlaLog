//
//  PatientController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/5/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import UIKit
import MapKit
extension PatientViewController{
    struct ViewModel {
        var hn : String!
        var name : String!
        var course : String!
        var deadline : Date!
        var startdate : Date!
        var enddate : Date!
        var passcode : String!
        var type : Int = 0
        var symptom : [String] = [String]()
        var diagnosis : [String] = [String]()
        var disease : [String] = [String]()
        var patientcareid : String = ""
        var rotationid : String = ""
        var latitude : Double = 0.0
        var longitude : Double = 0.0
        var rotationstarttime : Date!
        var verification : String = ""
        var message : String = ""
        var verificationid : String = ""
        var lbuserid : String = ""
        var verifydate : Date?
        var note : String = ""
        var verifystatus : Int = 0
    }
    func doClose(){
        self.dismiss(animated: true, completion: nil)
    }
    func addTeacherComment(){
        self.cons_bottom.constant = 4
        self.const_teacher_feedback_bottom.constant = 102
        self.cons_image_bottom.constant = 8
        if let  patient = BackRotation.getInstance().getPatientCare(id: self.patientcareid){
            if patient.verificationstatus == 0 || self.isTeacher{
                self.vw_signature.isHidden = true
            }else{
                if !(self.lb_message.text?.isEmpty)!{
                    self.lb_message.isHidden = false
                    self.const_teacher_feedback_bottom.constant += self.lb_message.frame.height + 8
                    self.cons_image_bottom.constant += self.lb_message.frame.height + 8
                }
                self.vw_signature.layoutIfNeeded()
                self.cons_bottom.constant += self.const_teacher_feedback_bottom.constant + 8
            }
        }else{
            self.vw_signature.isHidden = true
        }
    }
    //Symptom
    func loadSymptom(){
        BackPatient.getInstance().searchSymptom()
    }
    func initSymptomAutoCompleteUI(){
        self.tf_symptom.startVisibleWithoutInteraction = false
        let data = self.searchSymptom(key: "")
        self.tf_symptom.filterStrings(data)
    }
    func searchSymptom(key:String) ->[String]{
        let symptoms = BackPatient().listSymptom(key: key)
        var stsymptoms = [String]()
        for i in 0..<symptoms.count{
            stsymptoms.append(symptoms[i].name)
        }
        return stsymptoms
    }
    func doSearchSymptom(key:String){
        let data = self.searchSymptom(key: key)
        self.tf_symptom.filterStrings(data)
    }
    func addSymptom(key:String){
        if self.canAddTag(list: self.viewModel.symptom, title: key){
            if BackPatient.getInstance().getSymptom(key: key) != nil{
                self.viewModel.symptom.append(key)
            }else{
                if !key.isEmpty{
                    Helper.showWarning(sender: self, text: "Cannot add symptom outside autocomplete list")
                }
            }
            
        }else{
            if !key.isEmpty{
                Helper.showWarning(sender: self, text: "You cannot add a duplicate symptom")
            }
            
        }
        self.updateSymptomConstrain()
    }
    func deleteSymptom(key:String){
        if let index = self.removeTag(list: self.viewModel.symptom, title: key){
            self.viewModel.symptom.remove(at: index)
        }
        self.updateSymptomConstrain()
    }
    func updateSymptomConstrain(){
        self.cons_height_symptom_tag.constant = self.vw_symptom_tag.frame.height
        self.view.layoutIfNeeded()
    }
    //Diagnosis
    func loadDiagnosis(){
        BackPatient.getInstance().searchDiagnosis(key: "", finish: {
            
        })
    }
    func initDiagnosisAutoCompleteUI(){
        self.tf_diagnosis.startVisibleWithoutInteraction = false
        let data = self.searchSymptom(key: "")
        self.tf_diagnosis.filterStrings(data)
    }
    func searchDiagnosis(key:String) ->[String]{
        let diagnosis = BackPatient().listDiagnosis(key: key)
        var stdiagnosis = [String]()
        for i in 0..<diagnosis.count{
            stdiagnosis.append(diagnosis[i].name)
        }
        return stdiagnosis
    }
    func searchServerDiagnosis(key:String){
        BackPatient.getInstance().searchDiagnosis(key: key, finish: {
        })
    }
    func doSearchDiagnosis(key:String){
        let data = self.searchDiagnosis(key: key)
        self.tf_diagnosis.filterStrings(data)
    }
    func addDiagnosis(key:String){
        if self.canAddTag(list: self.viewModel.diagnosis, title: key){
            if let diag = BackPatient.getInstance().getDiagnosis(key: key){
                if let dise = BackPatient.getInstance().getDisease(id: diag.diseaseid){
                    #if GILOG
                    #else
                        self.addDisease(key: dise.name)
                    #endif
                }
            }
            self.viewModel.diagnosis.append(key)
        }else{
            if !key.isEmpty{
                Helper.showWarning(sender: self, text: "You cannot add a duplicate diagnosis")
            }
        }
        self.updateDiagnosisConstrain()
    }
    func deleteDiagnosis(key:String){
        if let index = self.removeTag(list: self.viewModel.diagnosis, title: key){
            self.viewModel.diagnosis.remove(at: index)
        }
        self.updateDiagnosisConstrain()
    }
    func updateDiagnosisConstrain(){
        self.cons_height_diagnosis_tag.constant = self.vw_diagnosis_tag.frame.height
        self.view.layoutIfNeeded()
    }
    //Disease
    func loadDisease(){
        BackPatient.getInstance().searchDisease()
    }
    func initDiseaseAutoCompleteUI(){
        self.tf_disease.startVisibleWithoutInteraction = false
        let data = self.searchDisease(key: "")
        self.tf_disease.filterStrings(data)
    }
    func searchDisease(key:String) ->[String]{
        let disease = BackPatient().listDisease(key: key)
        var stdisease = [String]()
        for i in 0..<disease.count{
            stdisease.append(disease[i].name)
        }
        return stdisease
    }
    func doSearchDisease(key:String){
        let data = self.searchDisease(key: key)
        self.tf_disease.filterStrings(data)
    }
    func addDisease(key:String){
        if self.canAddTag(list: self.viewModel.disease, title: key){
            if BackPatient.getInstance().getDisease(key: key) != nil{
                self.viewModel.disease.append(key)
            }else{
                if !key.isEmpty{
                    Helper.showWarning(sender: self, text: "Cannot add disease outside autocomplete list")
                }
            }
        }else{
            if !key.isEmpty{
               // Helper.showWarning(sender: self, text: "You cannot add a duplicate disease")
            }
        }
        self.updateDiseaseConstrain()
    }
    func deleteDisease(key:String){
        if let index = self.removeTag(list: self.viewModel.disease, title: key){
            self.viewModel.disease.remove(at: index)
        }
        self.updateDiseaseConstrain()
    }
    func updateDiseaseConstrain(){
        self.cons_height_disease_tag.constant = self.vw_disease_tag.frame.height
        self.view.layoutIfNeeded()
    }
    func limitTextfieldSize(textField:UITextField,maxSize:Int){
        if textField.text!.characters.count > maxSize{
            textField.deleteBackward()
        }
    }
    func canAddTag(list:[String],title:String) ->Bool{
        if title == ""{
            return false
        }
        for i in 0..<list.count{
            if list[i] == title{
                return false
            }
        }
        return true
    }
    func removeTag(list:[String],title:String) ->Int?{
        for i in 0..<list.count{
            if list[i] == title{
                return i
            }
        }
        return nil
    }
    
}
extension PatientViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000, 2000)
                self.map.setRegion(viewRegion, animated: false)
                var yourLocation = MKPointAnnotation()
        
                yourLocation.coordinate.latitude = userLocation.coordinate.latitude
                yourLocation.coordinate.longitude = userLocation.coordinate.longitude
                self.viewModel.latitude = userLocation.coordinate.latitude
                self.viewModel.longitude = userLocation.coordinate.longitude
                yourLocation.title = "Your Location"
                self.map.addAnnotation(yourLocation)
            }
        }
    }
}
extension PatientViewController.ViewModel{
    init(passcode:String="",type:Int=0,patientcare:PatientCare = PatientCare(),rotationid:String = "") {
        self.passcode = passcode
        self.type = patientcare.patienttype
        self.hn = patientcare.HN
        self.name = patientcare.name
        self.course = ""
        self.deadline = Date()
        self.startdate = Date()
        self.enddate = Date()
        self.patientcareid = patientcare.id
        self.note = patientcare.note
        if rotationid != ""{
            self.rotationid = rotationid
        }else{
            self.rotationid = patientcare.rotationid
        }
        if let verification = BackVerification.getInstance().get(id: patientcare.verifycodeid){
            self.verification = verification.verifycode
            self.verificationid = verification.id
        }
        self.lbuserid = patientcare.lbuserid
        self.verifydate = patientcare.verifytime
        self.message = patientcare.verifymessage
        self.verifystatus = patientcare.verificationstatus
        if let rotation = BackRotation.getInstance().get(id: self.rotationid){
            self.course = rotation.rotationname
            self.deadline = rotation.logbookendtime.addingTimeInterval(-1)
            self.rotationstarttime = rotation.starttime
            if patientcare.starttime == nil{
                self.startdate = rotation.starttime
            }else{
                self.startdate = patientcare.starttime!
            }
                if patientcare.endtime == nil{
                    #if GILOG
                    #else
                    self.enddate = rotation.endtime
                    #endif
                }else{
                    self.enddate = patientcare.endtime!
                }
        }
    }
    
}
