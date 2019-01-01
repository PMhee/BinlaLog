//
//  Logbook.swift
//  BinlaLog
//
//  Created by Tanakorn on 17/1/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
/*verify
pending = 0
accept = 1
reject = 2
 */
/*logtype
 observe = 0 server = 2
 asssist = 1 server = 0
 perform = 2 server = 1
 */
class Logbook:Object{
    @objc dynamic var HN : String = ""
    @objc dynamic var id : String = ""
    @objc dynamic var courseid : String = ""
    @objc dynamic var deviceid : String = ""
    @objc dynamic var donetime : Date = Date()
    @objc dynamic var feeling : Int = 0
    @objc dynamic var lbuserid : String = ""
    @objc dynamic var logtype : Int = 0
    @objc dynamic var mediafile : String = ""
    @objc dynamic var mediafileurl : String = ""
    @objc dynamic var patienttype : Int = 0
    var procedureid = List<ForeignProcedure>()
    @objc dynamic var rotationid : String = ""
    @objc dynamic var score : Double = 0.0
    @objc dynamic var updatetime : Date = Date()
    @objc dynamic var verifycode : String = ""
    @objc dynamic var verificationstatus : Int = 0
    @objc dynamic var verifycodeid : String = ""
    @objc dynamic var verifytime : Date?
    @objc dynamic var verifymessage : String = ""
    @objc dynamic var deletetime : Date?
    @objc dynamic var note : String = ""
    @objc dynamic var hospitalid : String = ""
    @objc dynamic var feelingMessage : String = ""
    @objc dynamic var latitude : Double = 0
    @objc dynamic var longitude : Double = 0
}
