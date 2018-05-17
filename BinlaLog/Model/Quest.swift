//
//  Quest.swift
//  BinlaLog
//
//  Created by Tanakorn on 16/5/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class Quest:Object{
    @objc dynamic var id : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var score : Double = 0.0
    @objc dynamic var des : String = ""
    @objc dynamic var courseid : String = ""
    var task = List<ForeignTask>()
    @objc dynamic var questRequirement : Int = 1
    @objc dynamic var questCount : Int = 0
    @objc dynamic var updatetime : Date = Date()
}
