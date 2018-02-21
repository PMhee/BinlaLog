//
//  Department.swift
//  BinlaLog
//
//  Created by Tanakorn on 9/2/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class Department:Object{
    @objc dynamic var id : String = ""
    @objc dynamic var departmentcode : String = ""
    @objc dynamic var departmentdesc : String = ""
    @objc dynamic var departmentname : String = ""
    @objc dynamic var picurl : String = ""
}
