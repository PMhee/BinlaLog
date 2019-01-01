//
//  Verification.swift
//  BinlaLog
//
//  Created by Tanakorn on 8/2/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class Verification:Object{
    @objc dynamic var id : String = ""
    @objc dynamic var lbuserid : String = ""
    @objc dynamic var verifycode : String = ""
    @objc dynamic var createtime : Date = Date()
    @objc dynamic var expiretime : Date = Date()
    @objc dynamic var canceltime : Date?
    @objc dynamic var limit : Int = 0
}
