//
//  Person.swift
//  BinlaLog
//
//  Created by Tanakorn on 9/2/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class Person:Object{
    @objc dynamic var id : String = ""
    @objc dynamic var firstname : String = ""
    @objc dynamic var gender : String = ""
    @objc dynamic var lastname : String = ""
    @objc dynamic var phoneno : String = ""
    @objc dynamic var picurl : String = ""
    @objc dynamic var title : String = ""
    @objc dynamic var userid : Int = 0
    @objc dynamic var usertype : Int = 0
    @objc dynamic var studentid : String = ""
    var departmentid = List<ForeignDepartment>()
}
