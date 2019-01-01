//
//  User.swift
//  BinlaLog
//
//  Created by Tanakorn on 12/25/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//
import Foundation
import RealmSwift
class User:Object{
    @objc dynamic var sessionid : String = ""
    @objc dynamic var passcode : String = ""
    @objc dynamic var role : String = ""
    @objc dynamic var id : String = ""
    @objc dynamic var advisor : String = ""
    @objc dynamic var batch : Int = 0
    @objc dynamic var coursename : String = ""
    @objc dynamic var email : String = ""
    @objc dynamic var enteryear : Int = 0
    @objc dynamic var entranceMeth : String = ""
    @objc dynamic var facebook : String = ""
    @objc dynamic var firstname : String = ""
    @objc dynamic var gender : String = ""
    @objc dynamic var isTest : Int = 0
    @objc dynamic var lastname : String = ""
    @objc dynamic var nickname : String = ""
    @objc dynamic var phoneno : String = ""
    @objc dynamic var picurl : String = ""
    @objc dynamic var place : String = ""
    @objc dynamic var pplid : String = ""
    @objc dynamic var procedure : Int = 0
    @objc dynamic var rank : Int = 0
    @objc dynamic var selfdescription : String = ""
    @objc dynamic var studentid : String = ""
    @objc dynamic var studentidno : String = ""
    @objc dynamic var studentidprefix : String = ""
    @objc dynamic var studentidsuffix : String = ""
    @objc dynamic var symptoms : Int = 0
    @objc dynamic var title : String = ""
    @objc dynamic var userid : Int = 0
    @objc dynamic var usertype : Int = 0
    @objc dynamic var currentSelectRotation : String = ""
    @objc dynamic var currentSelectVerification : Int = 0
    var currentRotation = List<ForeignRotation>()
    var recentRotation = List<ForeignRotation>()
    var notificationLogbook = List<ForeignLogbook>()
    var notificationPatient = List<ForeignPatientcare>()
}
