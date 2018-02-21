//
//  Procedure.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/11/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class Procedure:Object{
    @objc dynamic var id : String = ""
    @objc dynamic var assistScore : Int = 0
    @objc dynamic var des : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var performScore : Int = 0
    @objc dynamic var picfile : String = ""
    @objc dynamic var proctype : Int = 0
    @objc dynamic var searchKey : String = ""
    @objc dynamic var proceduregroup : String = ""
    @objc dynamic var observeMinReq : Int = 0
    @objc dynamic var observeScore : Int = 0
    @objc dynamic var assistMinReq : Int = 0
    @objc dynamic var performMinReq : Int = 0
}
