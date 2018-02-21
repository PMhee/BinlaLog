//
//  ProcedureGroup.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/11/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class ProcedureGroup:Object{
    @objc dynamic var id : String = ""
    @objc dynamic var procgroupdesc : String = ""
    @objc dynamic var procgroupname : String = ""
    @objc dynamic var picurl : String = ""
}
