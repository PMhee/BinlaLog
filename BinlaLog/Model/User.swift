//
//  User.swift
//  BinlaLog
//
//  Created by Tanakorn on 12/25/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//
import Foundation
import RealmSwift
class User:Object{
    @objc dynamic var sessionid : String = ""
    @objc dynamic var role : String = ""
}
