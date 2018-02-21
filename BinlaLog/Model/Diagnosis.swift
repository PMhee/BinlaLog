//
//  Diagnosis.swift
//  BinlaLog
//
//  Created by Tanakorn on 1/9/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class Diagnosis:Object{
    @objc dynamic var id : String = ""
    @objc dynamic var des : String = ""
    @objc dynamic var diseasegroup : String = ""
    @objc dynamic var diseaseid : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var visible : Int = 0
    var searchKey = List<DiagnosisSearchKey>()
}
