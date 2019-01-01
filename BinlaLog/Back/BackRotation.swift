//
//  BackRotation.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/10/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class BackRotation{
    static func getInstance() ->BackRotation{
        return BackRotation()
    }
    func loadRotation(dict:NSDictionary) ->String{
        var rotations = ""
        if let content = dict.value(forKey: "rotation") as? NSDictionary{
            BackCourse.getInstance().loadCourse(dict: content)
            try! Realm().write {
                var rotation = Rotation()
                if let id = content.value(forKey: "id") as? String{
                    rotation.id = id
                    rotations = id
                    if self.get(id: id) != nil{
                        rotation = self.get(id: id)!
                    }
                    if let user = BackUser.getInstance().get(){
                        if user.currentSelectRotation == ""{
                            user.currentSelectRotation = rotation.id
                        }
                    }
                }
                if let courseid = content.value(forKey: "courseid") as? String{
                    rotation.courseid = courseid
                }
                if let description = content.value(forKey: "description") as? String{
                    rotation.des = description
                }
                if let endtime = content.value(forKey: "endtime") as? String{
                    rotation.endtime = endtime.convertToDate()
                }
                if let logbookendtime = content.value(forKey: "logbookendtime") as? String{
                    rotation.logbookendtime = logbookendtime.convertToDate()
                }
                if let rotationname = content.value(forKey: "rotationname") as? String{
                    rotation.rotationname = rotationname
                }
                if let starttime = content.value(forKey: "starttime") as? String{
                    rotation.starttime = starttime.convertToDate()
                }
                if let updatetime = content.value(forKey: "updatetime") as? String{
                    rotation.updatetime = updatetime.convertToDate()
                }
                if let patientDone = dict.value(forKey: "patient") as? Int{
                    rotation.patientDone = patientDone
                }
                if let procedure = dict.value(forKey: "procedure") as? NSDictionary{
                    if let noCompleted = procedure.value(forKey: "noCompleted") as? Int{
                        rotation.noCompleted = noCompleted
                    }
                    if let noRequired = procedure.value(forKey: "noRequired") as? Int{
                        rotation.noRequired = noRequired
                    }
                    if let no = procedure.value(forKey: "no") as? Int{
                        rotation.noDone = no
                    }
                }
                if self.get(id: rotation.id) == nil{
                    self.post(object: rotation)
                }
            }
        }
        return rotations
    }
    func loadPatientCare(content:NSDictionary){
        var patientcare = PatientCare()
        self.loadRotation(dict: content)
        try! Realm().write {
            if let id = content.value(forKey: "id") as? String{
                patientcare.id = id
                if self.getPatientCare(id: id) != nil{
                    patientcare = self.getPatientCare(id:id)!
                }
            }
            if let HN = content.value(forKey: "HN") as? String{
                patientcare.HN = HN
            }
            if let courseid = content.value(forKey: "courseid") as? String{
                patientcare.courseid = courseid
            }
            if let endtime = content.value(forKey: "endtime") as? String{
                patientcare.endtime = endtime.convertToDate()
            }
            if let lbuserid = content.value(forKey: "lbuserid") as? String{
                patientcare.lbuserid = lbuserid
            }
            if let name = content.value(forKey: "name") as? String{
                patientcare.name = name
            }
            if let patienttype = content.value(forKey: "patienttype") as? Int{
                patientcare.patienttype = patienttype
            }
            if let picfile = content.value(forKey: "picfile") as? String{
                patientcare.picfile = picfile
            }
            if let picurl = content.value(forKey: "picurl") as? String{
                patientcare.picurl = picurl
            }
            if let rotationid = content.value(forKey: "rotationid") as? String{
                patientcare.rotationid = rotationid
            }
            if let starttime = content.value(forKey: "starttime") as? String{
                patientcare.starttime = starttime.convertToDate()
            }
            if let updatetime = content.value(forKey: "updatetime") as? String{
                patientcare.updatetime = updatetime.convertToDate()
            }
            if let deletetime = content.value(forKey: "deletetime") as? String{
                patientcare.deletetime = deletetime.convertToDate()
            }
            if let note = content.value(forKey: "note") as? String{
                patientcare.note = note
            }
            if let hospitalid = content.value(forKey: "hospitalid") as? String{
                patientcare.hospitalid = hospitalid
            }
            if let validation = content.value(forKey: "validation") as? NSDictionary{
                if let verifycodeid = validation.value(forKey: "verifycodeid") as? String{
                    patientcare.verifycodeid = verifycodeid
                }
                if let verifytime = validation.value(forKey: "verifytime") as? String{
                    patientcare.verifytime = verifytime.convertToDate()
                }
                if let verifystatus = validation.value(forKey: "verifystatus") as? Int{
                    patientcare.verificationstatus = verifystatus
                }
                if let verifymessage = validation.value(forKey: "verifymessage") as? String{
                    patientcare.verifymessage = verifymessage
                }
            }
            if let location = content.value(forKey: "location") as? NSArray{
                if location.count > 0 {
                    if let longitude = location[0] as? Double{
                        patientcare.longitude = longitude
                    }
                }
                if location.count > 1 {
                    if let latitude = location[1] as? Double{
                        patientcare.latitude = latitude
                    }
                }
            }
            patientcare.diagnosis.removeAll()
            patientcare.disease.removeAll()
            patientcare.symptom.removeAll()
        }
        if let student = content.value(forKey: "student") as? NSDictionary{
            BackUser.getInstance().loadPerson(content: student)
        }
        if let validation = content.value(forKey: "validation") as? NSDictionary{
            if let verifycode = validation.value(forKey: "verification") as? NSDictionary{
                BackVerification.getInstance().loadCode(content: verifycode)
            }
        }
        if let diagnosis = content.value(forKey: "diagnosis") as? NSArray{
            for k in 0..<diagnosis.count{
                if let dict = diagnosis[k] as? NSDictionary{
                    let foreignDiag = ForeignDiagnosis()
                    foreignDiag.diagnosisid = BackPatient.getInstance().loadDiagnosis(diagnosis: dict)
                    try! Realm().write {
                        patientcare.diagnosis.append(foreignDiag)
                    }
                }
            }
        }
        if let disease = content.value(forKey: "diseases") as? NSArray{
            for k in 0..<disease.count{
                if let dict = disease[k] as? NSDictionary{
                    let foreignDisease = ForeignDisease()
                    foreignDisease.diseaseid = BackPatient.getInstance().loadDisease(disease: dict)
                    try! Realm().write {
                        patientcare.disease.append(foreignDisease)
                    }
                }
            }
            
        }
        if let symptom = content.value(forKey: "symptoms") as? NSArray{
            for k in 0..<symptom.count{
                if let dict = symptom[k] as? NSDictionary{
                    let foreignSymptom = ForeignSymptom()
                    foreignSymptom.symptomid = BackPatient.getInstance().loadSymptom(symptom: dict)
                    try! Realm().write {
                        patientcare.symptom.append(foreignSymptom)
                    }
                }
            }
        }
        try! Realm().write {
            if self.getPatientCare(id: patientcare.id) == nil{
                self.post(object: patientcare)
            }
        }
    }
    func SelectCurrentRotation(finish: @escaping () -> Void,error: @escaping () -> Void){
        var rotations = [String]()
        APIRotation.getCurrentRotation(finish: {(success) in
                if let array = success.value(forKey: "content") as? NSArray{
                    for i in 0..<array.count{
                        if let content = array[i] as? NSDictionary{
                            rotations.append(self.loadRotation(dict: content))
                            BackCourse.getInstance().loadCourse(dict: content)
                        }
                    }
                }
                BackUser.getInstance().selectCurrentRotation(rotationid: rotations)
                finish()
        },error: {
            error()
        })
    }
    func getCurrentRotation(finish: @escaping () -> Void){
        var rotations = [String]()
        APIRotation.getCurrentRotation(finish: {(success) in
            if let array = success.value(forKey: "content") as? NSArray{
                for i in 0..<array.count{
                    if let content = array[i] as? NSDictionary{
                        rotations.append(self.loadRotation(dict: content))
                        BackCourse.getInstance().loadCourse(dict: content)
                    }
                }
            }
            BackUser.getInstance().putCurrentRotation(rotationid: rotations)
            finish()
        }, error: {
            
        })
    }
    func getRecentRotation(finish: @escaping () -> Void){
        var rotations = [String]()
        APIRotation.listRecentRotation(finish: {(success) in
            if let array = success.value(forKey: "content") as? NSArray{
                for i in 0..<array.count{
                    if let content = array[i] as? NSDictionary{
                        rotations.append(self.loadRotation(dict: content))
                        BackCourse.getInstance().loadCourse(dict: content)
                    }
                }
            }
            BackUser.getInstance().putRecentRotation(rotationid: rotations)
            finish()
        })
    }
    func listMyRotation() ->Results<Rotation>{
        var rotation = [String]()
        if let user = BackUser.getInstance().get(){
            for i in 0..<user.currentRotation.count{
                rotation.append(user.currentRotation[i].rotationid)
            }
            for i in 0..<user.recentRotation.count{
                rotation.append(user.recentRotation[i].rotationid)
            }
        }
        return try! Realm().objects(Rotation.self).filter("id IN %@",rotation).sorted(byKeyPath: "endtime", ascending: false)
    }
    //Logbook
    func deleteLogbook(logbookid:String,finish:@escaping () -> Void){
        APIRotation.deleteLogbook(logbookid:logbookid, finish: {(success) in
            finish()
        })
    }
    func EnumLogbook(updatetime:Date?,rotationid:String,finish: @escaping () -> Void){
        var date = ""
        if updatetime != nil{
            date = updatetime!.convertToServer()
        }
        APIRotation.listUpdatedLogbook(updatetime: date, rotationid: rotationid, finish: {(success) in
            if let data = success.value(forKey: "content") as? NSDictionary{
                if let array = data.value(forKey: "data") as? NSArray{
                    for i in 0..<array.count{
                        if let content = array[i] as? NSDictionary{
                            self.loadLogbook(content: content)
                            if let json = content.value(forKey: "procedure") as? NSDictionary{
                                BackProcedure.getInstance().loadProcedure(content: json)
                            }
                        }
                    }
                }
            }
            finish()
        })
    }
    func loadLogbook(content:NSDictionary){
        var logbook = Logbook()
        if let procedures = content.value(forKey: "procedures") as? NSArray{
            for i in 0..<procedures.count{
                if let procedure = procedures[i] as? NSDictionary{
                    BackProcedure.getInstance().loadProcedure(content: procedure)
                }
            }
        }
        self.loadRotation(dict: content)
        try! Realm().write {
            if let id = content.value(forKey: "id") as? String{
                logbook.id = id
                if self.getLogbook(id: id) != nil{
                    logbook = self.getLogbook(id: id)!
                }
            }
            if let HN = content.value(forKey: "HN") as? String{
                logbook.HN = HN
            }
            if let courseid = content.value(forKey: "courseid") as? String{
                logbook.courseid = courseid
            }
            if let deviceid = content.value(forKey: "deviceid") as? String{
                logbook.deviceid = deviceid
            }
            if let donetime = content.value(forKey: "donetime") as? String{
                logbook.donetime = donetime.convertToDate()
            }
            if let feeling = content.value(forKey: "performance") as? Int{
                logbook.feeling = feeling
            }
            if let feelingMessage = content.value(forKey:"feelingMsg") as? String{
                logbook.feelingMessage = feelingMessage
            }
            if let lbuserid = content.value(forKey: "lbuserid") as? String{
                logbook.lbuserid = lbuserid
            }
            if let note = content.value(forKey: "note") as? String{
                logbook.note = note
            }
            if let logtype = content.value(forKey: "logtype") as? Int{
                var lt = 0
                switch logtype{
                case 0:lt = 1
                case 1:lt = 2
                case 2:lt = 0
                default: lt = 0
                }
                logbook.logtype = lt
            }
            if let mediafile = content.value(forKey: "mediafile") as? String{
                logbook.mediafile = mediafile
            }
            if let mediafileurl = content.value(forKey: "mediafileurl") as? String{
                logbook.mediafileurl = mediafileurl
            }
            if let patienttype = content.value(forKey: "patienttype") as? Int{
                logbook.patienttype = patienttype
            }
            logbook.procedureid.removeAll()
            if let procedures = content.value(forKey: "procedureids") as? NSArray{
                for i in 0..<procedures.count{
                    if let procedureid = procedures[i] as? String{
                        let foreign = ForeignProcedure()
                        foreign.procedureid = procedureid
                        logbook.procedureid.append(foreign)
                    }
                }
                
            }
            if let rotationid = content.value(forKey: "rotationid") as? String{
                logbook.rotationid = rotationid
            }
            if let score = content.value(forKey: "score") as? Double{
                logbook.score = score
            }
            if let updatetime = content.value(forKey: "updatetime") as? String{
                logbook.updatetime = updatetime.convertToDate()
            }
            if let deletetime = content.value(forKey: "deletetime") as? String{
                logbook.deletetime = deletetime.convertToDate()
            }
            if let hospitalid = content.value(forKey: "hospitalid") as? String{
                logbook.hospitalid = hospitalid
            }
            if let location = content.value(forKey: "location") as? NSArray{
                if location.count > 0 {
                    if let longitude = location[0] as? Double{
                        logbook.longitude = longitude
                    }
                }
                if location.count > 1 {
                    if let latitude = location[1] as? Double{
                        logbook.latitude = latitude
                    }
                }
            }
            if let validation = content.value(forKey: "validation") as? NSDictionary{
                if let verifycodeid = validation.value(forKey: "verifycodeid") as? String{
                    logbook.verifycodeid = verifycodeid
                }
                if let verifytime = validation.value(forKey: "verifytime") as? String{
                    logbook.verifytime = verifytime.convertToDate()
                }
                if let verifystatus = validation.value(forKey: "verifystatus") as? Int{
                    logbook.verificationstatus = verifystatus
                }
                if let verifymessage = validation.value(forKey: "verifymessage") as? String{
                    logbook.verifymessage = verifymessage
                }
            }
            if self.getLogbook(id: logbook.id) == nil{
                self.post(object: logbook)
            }
        }
        if let validation = content.value(forKey: "validation") as? NSDictionary{
            if let verifycode = validation.value(forKey: "verification") as? NSDictionary{
                BackVerification.getInstance().loadCode(content: verifycode)
            }
        }
        if let student = content.value(forKey: "student") as? NSDictionary{
            BackUser.getInstance().loadPerson(content: student)
        }
    }
    func getLogbook(id:String) ->Logbook?{
        return try! Realm().objects(Logbook.self).filter("id == %@",id).first
    }
    func listLogbook(procedureid:String) ->Results<Logbook>{
        return try! Realm().objects(Logbook.self).filter("Any procedureid.procedureid == %@ AND deletetime == nil",procedureid)
    }
    func listLogbook() ->Results<Logbook>{
        return try! Realm().objects(Logbook.self).filter("deletetime == nil && verifytime != nil").sorted(byKeyPath: "verifytime", ascending: false)
    }
    func listLogbook(rotationid:String) ->Results<Logbook>{
        let verification = BackUser.getInstance().get()!.currentSelectVerification - 1
        if verification == -1{
            return try! Realm().objects(Logbook.self).filter("rotationid == %@ AND deletetime == nil",rotationid).sorted(byKeyPath: "updatetime", ascending: false)
        }else{
            return try! Realm().objects(Logbook.self).filter("rotationid == %@ AND verificationstatus == %@ AND deletetime == nil",rotationid,verification).sorted(byKeyPath: "updatetime", ascending: false)
        }
    }
    func listLogbook(rotationid:String,procedureid:String) ->Results<Logbook>{
        return try! Realm().objects(Logbook.self).filter("rotationid == %@ AND Any procedureid.procedureid == %@ AND deletetime == nil",rotationid,procedureid).sorted(byKeyPath: "updatetime", ascending: false)
    }
    func listLogbookProgress(procedureid:String,rotationid:String) ->[Int:Int]{
        var list = [Int:Int]()
        var temp : Results<Logbook>?
        if rotationid == ""{
            temp = try! Realm().objects(Logbook.self).filter("Any procedureid.procedureid == %@ AND deletetime == nil",procedureid)
        }else{
            temp = try! Realm().objects(Logbook.self).filter("Any procedureid.procedureid == %@ && rotationid == %@ AND deletetime == nil",procedureid,rotationid)
        }
        
        for i in 0..<temp!.count{
            if list[temp![i].logtype] == nil{
                list[temp![i].logtype] = 1
            }else{
                list[temp![i].logtype]! += 1
            }
        }
        return list
    }
    func updateLogbook(viewModel:ProcedureAddViewController.ViewModel,finish: @escaping (_ :NSDictionary) -> Void,error: @escaping () -> Void){
        var dvid = ""
        if viewModel.deviceid != ""{
            dvid = viewModel.deviceid
        }else{
            dvid = Helper.generateID()
        }
        var lt = 0
        switch viewModel.logtype {
        case 0:
            lt = 2
        case 1:
            lt = 0
        case 2:
            lt = 1
        default:
            lt = 0
        }
        var proc = [String]()
        for i in 0..<viewModel.procedures.count{
            if let procedure = BackProcedure.getInstance().get(key:viewModel.procedures[i]).first{
                proc.append(procedure.id)
            }
        }
        APIRotation.updateLogbook(logbookid: viewModel.logbookid,rotationid: viewModel.rotationid, HN: viewModel.hn+viewModel.hn_year, procedureid: proc, feeling: viewModel.feeling, location: "(\(viewModel.latitude),\(viewModel.longitude))", patienttype: viewModel.patientType, logtype: lt, donetime: viewModel.date.convertToServer(),deviceid: dvid,verification: viewModel.verification,latitude: viewModel.latitude,longitude: viewModel.longitude,note:viewModel.note,hospitalid: BackUser.getInstance().getHospital(name: viewModel.institute)?.id ?? "", feelingMessage: viewModel.feelingMessage, finish: {(success) in
            if let content = success.value(forKey: "content") as? NSDictionary{
                self.loadLogbook(content: content)
            }
            finish(success)
        },fail: {(err) in
            error()
        })
    }
    func summaryLogbookDone(rotationid:String) -> Results<Logbook>{
        return try! Realm().objects(Logbook.self).filter("rotationid == %@ AND deletetime == nil",rotationid)
    }
    func summaryProcedureDone(rotationid:String) ->[String:Int]{
        let temp = self.summaryLogbookDone(rotationid: rotationid)
        var sum = [String:Int]()
        for i in 0..<temp.count{
            for j in 0..<temp[i].procedureid.count{
                if sum[BackProcedure.getInstance().get(id: temp[i].procedureid[j].procedureid)?.name ?? ""] == nil{
                    sum[BackProcedure.getInstance().get(id: temp[i].procedureid[j].procedureid)?.name ?? ""] = 1
                }else{
                    sum[BackProcedure.getInstance().get(id: temp[i].procedureid[j].procedureid)?.name ?? ""]! += 1
                }
            }
        }
        return sum
    }
    func summaryMostProcedure(rotationid:String) ->String{
        let temp = self.summaryProcedureDone(rotationid: rotationid)
        var max = 0
        var value = ""
        for i in 0..<temp.count{
            if Array(temp.values)[i] > max{
                max = Array(temp.values)[i]
                value = Array(temp.keys)[i]
            }
        }
        return value
    }
    func summaryEmotion(rotationid:String,procedureid:String)->[Int:Int]{
        var result = [Int:Int]()
        var temp : Results<Logbook>?
        if rotationid == ""{
            temp = try! Realm().objects(Logbook.self).filter("Any procedureid.procedureid == %@ AND deletetime == nil",procedureid)
        }else{
            temp = try! Realm().objects(Logbook.self).filter("rotationid == %@ AND Any procedureid.procedureid == %@ AND deletetime == nil",rotationid,procedureid)
        }
        for i in 0..<temp!.count{
            if result[temp![i].feeling] == nil{
                result[temp![i].feeling] = 1
            }else{
                result[temp![i].feeling]! += 1
            }
        }
        return result
    }
    func getLogbookLastUpdateTime(rotationid:String) -> Date?{
        return try! Realm().objects(Logbook.self).filter("rotationid == %@ AND deletetime == nil",rotationid).sorted(byKeyPath: "updatetime", ascending: false).first?.updatetime
    }
    //Patient Care
    func deletePatient(patientid:String,finish:@escaping () -> Void){
        APIRotation.deletePatient(patientid:patientid, finish: {(success) in
            finish()
        })
    }
    func EnumPatientCare(updatetime:Date?,rotationid:String,finish: @escaping () -> Void){
        var date = ""
        if updatetime != nil{
            date = updatetime!.convertToServer()
        }
        APIRotation.listGrUpdatedPatientCare(updatetime: date,rotationid: rotationid, finish: {(success) in
            if let data = success.value(forKey: "content") as? NSDictionary{
                if let array = data.value(forKey: "data") as? NSArray{
                    for i in 0..<array.count{
                        if let json = array[i] as? NSDictionary{
                            self.loadPatientCare(content: json)
                        }
                    }
                    
                }
            }
            finish()
        })
    }
    func updatePatientCare(viewModel:PatientViewController.ViewModel,finish: @escaping () -> Void){
        var symptoms = [String]()
        var diseases = [String]()
        var diagnosiss = [String]()
        var dx = [String]()
        for i in 0..<viewModel.symptom.count{
            if let symptom = BackPatient.getInstance().getSymptom(key: viewModel.symptom[i]){
                symptoms.append(symptom.id)
            }
        }
        for i in 0..<viewModel.disease.count{
            if let disease = BackPatient.getInstance().getDisease(key: viewModel.disease[i]){
                diseases.append(disease.id)
            }
        }
        for i in 0..<viewModel.diagnosis.count{
            if let diagnosis = BackPatient.getInstance().getDiagnosis(key: viewModel.diagnosis[i]){
                diagnosiss.append(diagnosis.id)
            }else{
                dx.append(viewModel.diagnosis[i])
            }
        }

        APIRotation.updatePatientCare(name: viewModel.name, patientcareid:viewModel.patientcareid , HN: viewModel.hn+viewModel.hn_year, symptomid: symptoms,dx:dx, diagnosisid: diagnosiss, diseaseid: diseases, location: "(\(viewModel.latitude),\(viewModel.longitude))", starttime: viewModel.startdate.convertToServer(), endtime: viewModel.enddate.convertToServer(), rotationid: viewModel.rotationid,latitude: viewModel.latitude,longitude: viewModel.longitude,patienttype: viewModel.type,verification:viewModel.verification,note:viewModel.note,hospitalid: BackUser.getInstance().getHospital(name: viewModel.institute)?.id ?? "", finish: {(success) in
            if let content = success.value(forKey: "content") as? NSDictionary{
                self.loadPatientCare(content: content)
            }
            finish()
        })
    }
    func getLastUpdateTime(rotationid:String) -> Date?{
        return try! Realm().objects(PatientCare.self).filter("rotationid == %@ AND deletetime == nil",rotationid).sorted(byKeyPath: "updatetime", ascending: false).first?.updatetime
    }
    func listPatientCare(rotationid:String) ->Results<PatientCare>{
        let verification = BackUser.getInstance().get()!.currentSelectVerification - 1
        if verification == -1{
            return try! Realm().objects(PatientCare.self).filter("rotationid == %@ AND deletetime == nil",rotationid).sorted(byKeyPath: "updatetime", ascending: false)
        }else{
            return try! Realm().objects(PatientCare.self).filter("rotationid == %@ AND verificationstatus == %@ AND deletetime == nil",rotationid,verification).sorted(byKeyPath: "updatetime", ascending: false)
        }
        
    }
    func listPatientCare() ->Results<PatientCare>{
        return try! Realm().objects(PatientCare.self).filter("deletetime == nil && verifytime != nil").sorted(byKeyPath: "verifytime", ascending: false)
    }
    func listPatientCare(rotationid:String,symptomid:String,diseaseid:String,diagnosisid:String) ->Results<PatientCare>{
        if !symptomid.isEmpty{
            return try! Realm().objects(PatientCare.self).filter("rotationid == %@ AND ANY symptom.symptomid == %@ AND deletetime == nil",rotationid,symptomid).sorted(byKeyPath: "updatetime", ascending: false)
        }else if !diseaseid.isEmpty{
            return try! Realm().objects(PatientCare.self).filter("rotationid == %@ AND ANY disease.diseaseid == %@ AND deletetime == nil",rotationid,diseaseid).sorted(byKeyPath: "updatetime", ascending: false)
        }else{
            return try! Realm().objects(PatientCare.self).filter("rotationid == %@ AND ANY diagnosis.diagnosisid == %@ AND deletetime == nil",rotationid,diagnosisid).sorted(byKeyPath: "updatetime", ascending: false)
        }
        
    }
    func getPatientCare(id:String) ->PatientCare?{
        return try! Realm().objects(PatientCare.self).filter("id == %@",id).first
    }
    func summaryPatientCare(rotationid:String) ->Results<PatientCare>{
        return try! Realm().objects(PatientCare.self).filter("rotationid == %@ AND deletetime == nil",rotationid)
    }
    func summarySymptom(rotationid:String) ->[String:Int]{
        var value = [String:Int]()
        let temp = self.summaryPatientCare(rotationid: rotationid)
        for i in 0..<temp.count{
            for j in 0..<temp[i].symptom.count{
                if value[BackPatient.getInstance().getSymptom(id: temp[i].symptom[j].symptomid)?.name ?? ""] == nil{
                    value[BackPatient.getInstance().getSymptom(id: temp[i].symptom[j].symptomid)?.name ?? ""] = 1
                }else{
                    value[BackPatient.getInstance().getSymptom(id: temp[i].symptom[j].symptomid)?.name ?? ""]! += 1
                }
            }
        }
        return value
    }
    func summaryDiagnosis(rotationid:String) ->[String:Int]{
        var value = [String:Int]()
        let temp = self.summaryPatientCare(rotationid: rotationid)
        for i in 0..<temp.count{
            for j in 0..<temp[i].diagnosis.count{
                if value[BackPatient.getInstance().getDiagnosis(id: temp[i].diagnosis[j].diagnosisid)?.name ?? ""] == nil{
                    value[BackPatient.getInstance().getDiagnosis(id: temp[i].diagnosis[j].diagnosisid)?.name ?? ""] = 1
                }else{
                    value[BackPatient.getInstance().getDiagnosis(id: temp[i].diagnosis[j].diagnosisid)?.name ?? ""]! += 1
                }
                
            }
        }
        return value
    }
    func summaryDisease(rotationid:String) ->[String:Int]{
        var value = [String:Int]()
        let temp = self.summaryPatientCare(rotationid: rotationid)
        for i in 0..<temp.count{
            for j in 0..<temp[i].disease.count{
                if value[BackPatient.getInstance().getDisease(id: temp[i].disease[j].diseaseid)?.name ?? ""] == nil{
                    value[BackPatient.getInstance().getDisease(id: temp[i].disease[j].diseaseid)?.name ?? ""] = 1
                }else{
                    value[BackPatient.getInstance().getDisease(id: temp[i].disease[j].diseaseid)?.name ?? ""]! += 1
                }
                
            }
        }
        return value
    }
    //Query
    func get(id:String) ->Rotation?{
        return try! Realm().objects(Rotation.self).filter("id == %@",id).first
    }
    func post(object:Object){
        try! Realm().add(object)
    }
}
