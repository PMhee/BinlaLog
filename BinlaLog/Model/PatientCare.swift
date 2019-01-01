//
//  PatientCare.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/15/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class PatientCare:Object{
    @objc dynamic var HN : String = ""
    @objc dynamic var id : String = ""
    @objc dynamic var courseid : String = ""
    @objc dynamic var endtime : Date?
    @objc dynamic var lbuserid : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var picfile : String = ""
    @objc dynamic var picurl : String = ""
    @objc dynamic var rotationid : String = ""
    @objc dynamic var starttime : Date?
    @objc dynamic var updatetime : Date = Date()
    @objc dynamic var patienttype : Int = 0
    var diagnosis = List<ForeignDiagnosis>()
    var symptom = List<ForeignSymptom>()
    var disease = List<ForeignDisease>()
    @objc dynamic var verificationstatus : Int = 0
    @objc dynamic var deletetime : Date?
    @objc dynamic var verifycodeid : String = ""
    @objc dynamic var verifymessage : String = ""
    @objc dynamic var verifytime : Date?
    @objc dynamic var note : String = ""
    @objc dynamic var hospitalid : String = ""
    @objc dynamic var latitude : Double = 0
    @objc dynamic var longitude : Double = 0
}
