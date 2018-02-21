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
    
    func initProcedureAutoCompleteUI(){
        self.tf_procedure.startVisibleWithoutInteraction = false
        let data = self.searchProcedure(key: "")
        self.tf_procedure.filterStrings(data)
    }
    func initLogbook(){
        if let  logbook = BackRotation.getInstance().getLogbook(id: self.logbookid){
            self.viewModel.hn = logbook.HN
            self.viewModel.patientType = logbook.patienttype
            self.viewModel.feeling = logbook.feeling
            self.viewModel.date = logbook.donetime
            self.viewModel.logtype = logbook.logtype
            self.viewModel.logbookid = logbook.id
            self.viewModel.message = logbook.verifymessage
            self.viewModel.note = logbook.note
            self.logbookid = logbook.id
            self.viewModel.deviceid = logbook.deviceid
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
            self.lb_verification_date.watch(subject: logbook.verifytime?.convertToStringOnlyDate() ?? "")
            if let proc = BackProcedure.getInstance().get(id: logbook.procedureid){
                self.procedureid = proc.id
                self.initProcedure()
            }
            if let rotate = BackRotation.getInstance().get(id: logbook.rotationid){
                self.rotationid = rotate.id
                self.initRotation()
            }
            if logbook.verificationstatus == 0 {
                self.vw_signature.isHidden = true
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
        }
    }
    func initProcedure(){
        if let procedure = BackProcedure.getInstance().get(id: procedureid){
            self.viewModel.procedureName = procedure.name
            self.viewModel.procedureid = procedure.id
        }
    }
    func validateProcedure(text:String){
        if let procedure = BackProcedure.getInstance().get(key: text).first{
            self.viewModel.procedureName = procedure.name
            self.viewModel.procedureid = procedure.id
        }else{
            self.viewModel.procedureName = ""
            Helper.showWarning(sender: self, text: "Use cannot add procedure outside list")
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
    struct ViewModel {
        var rotationname : String = ""
        var rotationdeadline : Date = Date()
        var rotationstarttime : Date = Date()
        var rotationid : String = ""
        var procedureName : String = ""
        var hn : String = ""
        var patientType : Int = 0
        var feeling : Int = -1
        var date : Date = Date()
        var verification : String = ""
        var logtype : Int = 2
        var logbookid : String = ""
        var latitude : Double = 0.0
        var longitude : Double = 0.0
        var procedureid : String = ""
        var deviceid : String = ""
        var message : String = ""
        var verificationid :String = ""
        var note : String = ""
    }
}
extension ProcedureAddViewController:CLLocationManagerDelegate{
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

