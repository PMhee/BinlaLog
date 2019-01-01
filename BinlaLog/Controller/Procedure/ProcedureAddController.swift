//
//  ProcedureAddController.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/12/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import UIKit
import MapKit
extension ProcedureAddViewController{
    func initHospital(){
        BackUser.getInstance().enumHospital {
            self.viewModel.hospitals = Array(BackUser.getInstance().listHospital())
            if self.viewModel.hospitals.count > 0 {
                self.viewModel.institute = self.viewModel.institute.isEmpty && !self.isTeacher ? self.viewModel.hospitals[self.findNearestHospital()].name : self.viewModel.institute
            }
        }
        self.viewModel.hospitals = Array(BackUser.getInstance().listHospital())
        if self.viewModel.hospitals.count > 0 {
            self.viewModel.institute = self.viewModel.institute.isEmpty && !self.isTeacher ? self.viewModel.hospitals[self.findNearestHospital()].name : self.viewModel.institute
        }
    }
    func findNearestHospital() -> Int{
        var min = 999999999999999.0
        var index = 0
        let latitude = self.viewModel.latitude
        let longitude = self.viewModel.longitude
        for i in 0..<self.viewModel.hospitals.count{
            let distance =  sqrt(pow((latitude - self.viewModel.hospitals[i].latitude),2) + pow((longitude - self.viewModel.hospitals[i].longitude),2))
            if min > distance{
                min = distance
                index = i
            }
        }
        return index
    }
    func initProcedureAutoCompleteUI(){
        self.tf_procedure.startVisibleWithoutInteraction = false
        let data = self.searchProcedure(key: "")
        self.tf_procedure.filterStrings(data)
    }
    func initProcedure(){
        self.viewModel.procedures = []
        if !self.procedureid.isEmpty{
            if let proc = BackProcedure.getInstance().get(id: self.procedureid){
                self.viewModel.procedures.append(proc.name)
            }
        }else if self.procedureids.count > 0{
            for i in 0..<self.procedureids.count{
                if let proc = BackProcedure.getInstance().get(id: self.procedureids[i]){
                    self.viewModel.procedures.append(proc.name)
                }
            }
        }
        self.updateProcedureConstrain()
    }
    func initLogbook(){
        if let  logbook = BackRotation.getInstance().getLogbook(id: self.logbookid){
            if logbook.HN.count > 2 {
                self.viewModel.hn = logbook.HN.substring(to: logbook.HN.count-2)
                self.viewModel.hn_year = logbook.HN.substring(from: logbook.HN.count-2)
            }else{
                self.viewModel.hn = logbook.HN
            }
            self.viewModel.patientType = logbook.patienttype
            self.viewModel.feeling = logbook.feeling
            self.viewModel.date = logbook.donetime
            self.viewModel.logtype = logbook.logtype
            self.viewModel.logbookid = logbook.id
            self.viewModel.message = logbook.verifymessage
            self.viewModel.latitude = logbook.latitude
            self.viewModel.longitude = logbook.longitude
            self.viewModel.note = logbook.note
            self.logbookid = logbook.id
            self.viewModel.deviceid = logbook.deviceid
            self.viewModel.feelingMessage = logbook.feelingMessage
            if let verification = BackVerification.getInstance().get(id: logbook.verifycodeid){
                if let teacher = BackUser.getInstance().getPerson(id: verification.lbuserid){
                    Helper.loadLocalImage(id: teacher.id, success: {(image) in
                        self.img_teacher_profile.image = image
                    })
                    self.lb_teacher_name.watch(subject: teacher.firstname+" "+teacher.lastname)
                }
                self.viewModel.verification = verification.verifycode
                self.viewModel.verificationid = verification.id
            }
            self.viewModel.verifystatus = logbook.verificationstatus
            self.lb_verification_date.watch(subject: logbook.verifytime?.convertToStringOnlyDate() ?? "")
            self.viewModel.procedures = []
            for i in 0..<logbook.procedureid.count{
                if let proc = BackProcedure.getInstance().get(id: logbook.procedureid[i].procedureid){
                    self.viewModel.procedures.append(proc.name)
                }
            }
            self.updateProcedureConstrain()
            if let rotate = BackRotation.getInstance().get(id: logbook.rotationid){
                self.rotationid = rotate.id
                self.initRotation()
            }
            if logbook.verificationstatus == 0 {
                self.vw_signature.isHidden = true
            }
            if let hospital = BackUser.getInstance().getHospital(id: logbook.hospitalid) {
                self.viewModel.institute = hospital.name
            }
            if self.viewModel.note.isEmpty{
                self.lb_note_placeholder.isHidden = false
            }else{
                self.lb_note_placeholder.isHidden = true
            }
            self.tv_note.text = self.viewModel.note
        }
    }
    func addTeacherComment(){
        self.cons_bottom.constant = 4
        self.const_teacher_feedback_bottom.constant = 102
        self.vw_quest.layoutIfNeeded()
        self.cons_course_top.constant = self.isTask ? self.vw_quest.frame.height + 8 : 4
        self.cons_image_bottom.constant = 8
        if let  logbook = BackRotation.getInstance().getLogbook(id: self.logbookid){
            if logbook.verificationstatus == 0 || self.isTeacher{
                self.vw_signature.isHidden = true
            }else{
                if !(self.lb_message.text?.isEmpty)!{
                    self.lb_message.isHidden = false
                    self.const_teacher_feedback_bottom.constant += self.lb_message.frame.height + 8
                    self.cons_image_bottom.constant += self.lb_message.frame.height + 8
                }
                self.vw_signature.layoutIfNeeded()
                self.cons_bottom.constant += self.const_teacher_feedback_bottom.constant + 8
                self.cons_course_top.constant += self.const_teacher_feedback_bottom.constant + 8
            }
        }else{
            self.vw_signature.isHidden = true
        }
    }
    func initRotation(){
        if let rotation = BackRotation.getInstance().get(id: self.rotationid){
            self.viewModel.rotationid = rotation.id
            self.viewModel.rotationname = rotation.rotationname
            self.viewModel.rotationdeadline = rotation.logbookendtime
            self.viewModel.rotationstarttime = rotation.starttime
            self.viewModel.rotationendtime = rotation.endtime
        }
    }
    func searchProcedure(key:String) ->[String]{
        var stProcedure = [String]()
        let results = BackProcedure.getInstance().get(key: key)
        for i in 0..<results.count{
            stProcedure.append(results[i].name)
        }
        return stProcedure
    }
    func limitTextfieldSize(textField:UITextField,maxSize:Int) ->Bool{
        if textField.text!.characters.count > maxSize{
            textField.deleteBackward()
            return false
        }
        return true
    }
    func changeFeeling(){
        self.img_feel_1.setImage(UIImage(named:"emotion-angry-grey.png"), for: .normal)
        self.img_feel_2.setImage(UIImage(named:"emotion-crying-grey.png"), for: .normal)
        self.img_feel_3.setImage(UIImage(named:"emotion-straight-grey.png"), for: .normal)
        self.img_feel_4.setImage(UIImage(named:"emotion-smile-grey.png"), for: .normal)
        self.img_feel_5.setImage(UIImage(named:"emotion-love-grey.png"), for: .normal)
        switch self.viewModel.feeling {
        case 0:
            self.img_feel_1.setImage(UIImage(named:"emotion-angry.png"), for: .normal)
        case 1:
            self.img_feel_2.setImage(UIImage(named:"emotion-crying.png"), for: .normal)
        case 2:
            self.img_feel_3.setImage(UIImage(named:"emotion-straight.png"), for: .normal)
        case 3:
            self.img_feel_4.setImage(UIImage(named:"emotion-smile.png"), for: .normal)
        case 4:
            self.img_feel_5.setImage(UIImage(named:"emotion-love.png"), for: .normal)
        default:
            print()
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
    func addProcedure(key:String){
        if self.canAddTag(list: self.viewModel.procedures, title: key){
            if BackProcedure.getInstance().get(key: key).first != nil{
                self.viewModel.procedures.append(key)
            }else{
                if !key.isEmpty{
                    Helper.showWarning(sender: self, text: "Cannot add procedure outside autocomplete list")
                }
            }
        }else{
            if !key.isEmpty{
                Helper.showWarning(sender: self, text: "You cannot add a duplicate procedure")
            }
        }
        self.tf_procedure.text = ""
        self.updateProcedureConstrain()
    }
    func deleteProcedure(key:String){
        if let index = self.removeTag(list: self.viewModel.procedures, title: key){
            self.viewModel.procedures.remove(at: index)
        }
        self.updateProcedureConstrain()
    }
    func updateProcedureConstrain(){
        self.const_height_procedure_tag.constant = self.tag_procedure.frame.height
        self.view.layoutIfNeeded()
    }
    struct ViewModel {
        var procedures = [String]()
        var rotationname : String = ""
        var rotationdeadline : Date = Date()
        var rotationstarttime : Date = Date()
        var rotationendtime : Date = Date()
        var rotationid : String = ""
        var procedureName : String = ""
        var hn : String = ""
        var hn_year : String = ""
        var patientType : Int = 0
        var feeling : Int = -1
        var date : Date = Date()
        var verification : String = ""
        var logtype : Int = 2
        var logbookid : String = ""
        var latitude : Double = 0.0
        var longitude : Double = 0.0
        var deviceid : String = ""
        var message : String = ""
        var verificationid :String = ""
        var note : String = ""
        var verifystatus : Int = 0
        var institute : String = ""
        var hospitals = [Hospital]()
        var feelingMessage : String = ""
        var questId : String = ""
        var taskId : String = ""
    }
}
extension ProcedureAddViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                var yourLocation = MKPointAnnotation()
                print(self.viewModel.latitude,self.viewModel.longitude)
                if self.viewModel.latitude != 0.0 && self.viewModel.longitude != 0.0 {
                    yourLocation.coordinate.latitude = self.viewModel.latitude
                    yourLocation.coordinate.longitude = self.viewModel.longitude
                    yourLocation.title = "Location"
                    self.map.addAnnotation(yourLocation)
                }else{
                    yourLocation.coordinate.latitude = userLocation.coordinate.latitude
                    yourLocation.coordinate.longitude = userLocation.coordinate.longitude
                    self.viewModel.latitude = userLocation.coordinate.latitude
                    self.viewModel.longitude = userLocation.coordinate.longitude
                    yourLocation.title = "Location"
                    self.map.addAnnotation(yourLocation)
                }
                let viewRegion = MKCoordinateRegionMakeWithDistance(yourLocation.coordinate, 2000, 2000)
                self.map.setRegion(viewRegion, animated: false)
                self.initHospital()
            }
        }
    }
    
}

