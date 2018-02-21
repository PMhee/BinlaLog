//
//  Course.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/10/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class Course:Object{
    @objc dynamic var id : String = ""
    @objc dynamic var collegeyear : Int = 0
    @objc dynamic var coursecode : String = ""
    @objc dynamic var coursename : String = ""
    @objc dynamic var coursename_abbr : String = ""
    @objc dynamic var coursename_s : String = ""
    @objc dynamic var departmentid : String = ""
    @objc dynamic var departmentname : String = ""
    @objc dynamic var des : String = ""
    @objc dynamic var picurl : String = ""
    @objc dynamic var year : Int = 0
    var procgroupids = List<ForeignProcgroup>()
}
