//
//  Task.swift
//  BinlaLog
//
//  Created by Tanakorn on 16/5/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class Task:Object{
    @objc dynamic var id : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var des : String = ""
    @objc dynamic var place : String = ""
    @objc dynamic var isNeedVerify : Bool = false
    @objc dynamic var taskNo : Int = 0
    @objc dynamic var questid : String = ""
    @objc dynamic var datetime : Date?
    var taskLogProcedure = List<ForeignProcedure>()
    var taskLogPatient = List<ForeignPatientcare>()
    @objc dynamic var type : Int = 0
    @objc dynamic var updatetime : Date = Date()
    @objc dynamic var noLog : Int = 0 
}
