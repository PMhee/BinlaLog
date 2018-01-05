//
//  BackUser.swift
//  BinlaLog
//
//  Created by Tanakorn on 12/25/2560 BE.
//  Copyright © 2560 Tanakorn. All rights reserved.
//

import Foundation
import RealmSwift
class BackUser{
    static func getInstance() ->BackUser{
        return BackUser()
    }
    func login(success:NSDictionary){
        if let content = success.value(forKey: "content") as? NSDictionary{
            let user = User()
            if let role = content.value(forKey: "role") as? String{
                user.role = role
            }
            if let sessionid = content.value(forKey: "sessionid") as? String{
                user.sessionid = sessionid
            }
            if self.list().count == 0 {
                self.post(user: user)
            }
        }
    }
    func get() -> User?{
        return try! Realm().objects(User.self).first
    }
    func post(user:User){
        try! Realm().write {
            try! Realm().add(user)
        }
        
    }
    func list() -> Results<User>{
        return try! Realm().objects(User.self)
    }
    func removeAll(){
        try! Realm().write {
            try! Realm().deleteAll()
        }
    }
}
