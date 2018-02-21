//
//  Rotation.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/10/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class Rotation:Object{
    @objc dynamic var id : String = ""
    @objc dynamic var courseid : String = ""
    @objc dynamic var des : String = ""
    @objc dynamic var endtime : Date = Date()
    @objc dynamic var logbookendtime : Date = Date()
    @objc dynamic var rotationname : String = ""
    @objc dynamic var starttime : Date = Date()
    @objc dynamic var updatetime : Date  = Date()
    @objc dynamic var patientDone : Int = 0
    @objc dynamic var noCompleted : Int = 0
    @objc dynamic var noRequired : Int = 0
    @objc dynamic var noDone : Int = 0
}
