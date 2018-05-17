//
//  Hospital.swift
//  BinlaLog
//
//  Created by Tanakorn on 4/4/2561 BE.
//  Copyright © 2561 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class Hospital:Object{
    @objc dynamic var id : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var latitude : Double = 0.0
    @objc dynamic var longitude : Double = 0.0
}
